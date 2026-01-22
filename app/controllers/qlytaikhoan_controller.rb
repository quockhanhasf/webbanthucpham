class QlytaikhoanController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [ :index ]

  def index
    @users = Taikhoan.all
    @user_data = @users.map do |user|
      orders = Donhang.where(hoten: user.hoten)
      total_spent = orders.sum(:tongthanhtoan)

      # Tính sản phẩm được mua nhiều nhất
      product_counts = orders.each_with_object(Hash.new(0)) do |order, counts|
        product_names = order.thongtinsanpham.split(",") # Giả sử sản phẩm cách nhau bởi dấu phẩy
        product_names.each { |product| counts[product.strip] += 1 }
      end
      most_bought_product = product_counts.max_by { |_, count| count }&.first || "Không có dữ liệu"
      # Tính chi phí đơn hàng cao nhất
      max_order_cost = orders.maximum(:tongthanhtoan) || 0
      # Tính tổng số đơn hàng
      total_orders = orders.count
      canceled_orders_count = orders.where(trangthai: "Huỷ đơn hàng").count
      {
        user: user,
        orders: orders,
        total_spent: total_spent,
        most_bought_product: most_bought_product,
        max_order_cost: max_order_cost,
        total_orders: total_orders,
        canceled_orders_count: canceled_orders_count

      }
    end
  end

  def khoa_mo_taikhoan
    user = Taikhoan.find(params[:id])
    new_quyen = params[:quyen]
    if user.update(quyen: new_quyen)
      render json: { message: "Tài khoản đã được cập nhật trạng thái." }, status: :ok
    else
      render json: { message: "Không thể cập nhật trạng thái tài khoản." }, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập trang này." unless current_user&.quyen == "admin"
  end
end
