class CartController < ApplicationController
  before_action :require_login # Đảm bảo người dùng đã đăng nhập
  skip_before_action :verify_authenticity_token, only: [ :set_selected_products ]


  def set_selected_products
    selected_products = params[:selected_products] || []

    if selected_products.is_a?(Array)
      session[:selected_products] = selected_products.to_json
      render json: { success: true }
    else
      render json: { success: false, error: "Danh sách sản phẩm không hợp lệ" }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("Lỗi trong set_selected_products: #{e.message}")
    render json: { success: false, error: "Có lỗi xảy ra, vui lòng thử lại." }, status: :internal_server_error
  end

  def add_to_cart
    product_name = params[:product_name]
    quantity = params[:quantity]


    # Lấy tài khoản hiện tại
    current_account = current_user

    # Lấy thông tin giỏ hàng hiện tại, nếu chưa có thì tạo mới
    cart = current_account.giohang.present? ? JSON.parse(current_account.giohang) : {}

    # Thêm hoặc cập nhật sản phẩm trong giỏ hàng
    if cart[product_name]
      cart[product_name] += quantity.to_f
    else
      cart[product_name] = quantity.to_f
    end

    # Lưu lại giỏ hàng
    current_account.update(giohang: cart.to_json)

    session[:selected_products] = nil
    render json: { success: true, cart: cart }, status: :ok
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end





  # Xóa sản phẩm khỏi giỏ hàng
  def remove_from_cart
    product_name = params[:product_name]

    # Lấy tài khoản hiện tại
    current_account = current_user

    # Lấy thông tin giỏ hàng hiện tại
    cart = current_account.giohang.present? ? JSON.parse(current_account.giohang) : {}

    # Xóa sản phẩm nếu tồn tại
    if cart.key?(product_name)
      cart.delete(product_name)
      current_account.update(giohang: cart.to_json)
      render json: { success: true, cart: cart }, status: :ok
    else
      render json: { success: false, error: "Sản phẩm không tồn tại trong giỏ hàng." }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end





  def update_cart
    product_name = params[:product_name]
    new_quantity = params[:quantity].to_f

    # Lấy thông tin giỏ hàng
    cart = current_user.giohang.present? ? JSON.parse(current_user.giohang) : {}

    # Cập nhật số lượng sản phẩm
    if cart[product_name]
      cart[product_name] = new_quantity
      current_user.update(giohang: cart.to_json)
      render json: { success: true, cart: cart }, status: :ok
    else
      render json: { success: false, error: "Sản phẩm không tồn tại trong giỏ hàng." }, status: :unprocessable_entity
    end
  end






  def order
    @selected_products = if session[:selected_products].is_a?(String) && !session[:selected_products].empty?
                           JSON.parse(session[:selected_products]) rescue []
    else
                           []
    end

    if @selected_products.empty?
      flash[:alert] = "Vui lòng chọn ít nhất một sản phẩm để đặt hàng."
      redirect_to cart_path
      return
    end

    # Tìm sản phẩm theo tên và số lượng từ giỏ hàng
    cart = current_user.giohang.present? ? JSON.parse(current_user.giohang) : {}
    @products = @selected_products.map do |product_name|
      product = Sanpham.find_by(ten: product_name)
      if product
        quantity = cart[product_name] || 0
        { name: product_name, product: product, quantity: quantity }
      else
        nil
      end
    end.compact

    @payment_status = params[:payment_status] || "pending"
  end

















  def create_order
    # Lấy dữ liệu từ params
    hoten = params[:fullname]
    sdt = params[:phone]
    xa = params[:ward]
    huyen = params[:district]
    tinh = params[:province]
    diachi_cuthe = params[:address]
    diachi = "#{diachi_cuthe}, #{xa}, #{huyen}, #{tinh}" # Địa chỉ đầy đủ
    trangthaithanhtoan = params[:payment_status]
    tongthanhtoan = params[:total_payment]
    trangthai = params[:trangthai]
    tensanpham = @products.map { |item| item[:product].ten }.join(", ")
    soluong = @products.map { |item| item[:quantity].to_i }.join(", ")

    # Tạo và lưu đơn hàng
    donhang = Donhang.new(
      hoten: hoten,
      sdt: sdt,
      xa: xa,
      huyen: huyen,
      tinh: tinh,
      diachi: diachi,
      tongthanhtoan: tongthanhtoan,
      trangthaithanhtoan: trangthaithanhtoan,
      trangthai: trangthai,
      tensanpham: tensanpham,
      soluong: soluong,
      ngaydathang: Time.current
    )

    # Kiểm tra và xử lý kết quả
    if donhang.save
      flash[:success] = "Đặt hàng thành công!"
      redirect_to root_path
    else
      flash[:error] = "Đặt hàng thất bại. Vui lòng kiểm tra lại thông tin."
      redirect_to cart_path
    end
  end



  private

  def require_login
    unless current_user
      render json: { success: false, error: "Bạn cần đăng nhập để sử dụng giỏ hàng." }, status: :unauthorized
    end
  end
end
