class GiaohangController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @donhangs = Donhang.all

    if params[:search].present?
      search_term = params[:search].downcase
      @donhangs = @donhangs.where("LOWER(hoten) LIKE ? OR LOWER(sdt) LIKE ? OR LOWER(email) LIKE ? OR LOWER(diachi) LIKE ?",
                                 "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
    end

    # Nếu muốn tìm kiếm theo ngày tháng, bạn có thể sử dụng:
    if params[:date].present?
      begin
        date = Date.parse(params[:date])
        @donhangs = @donhangs.where("DATE(ngaydathang) = ?", date)
      rescue ArgumentError
        flash[:error] = "Ngày không hợp lệ"
      end
    end

    @donhangs = @donhangs.order(ngaydathang: :desc)
  end

  def xacnhan
    donhang = Donhang.find(params[:id])

    # Tách các sản phẩm từ thuộc tính thongtinsanpham
    sanpham_details = donhang.thongtinsanpham.to_s.split(",").map(&:strip)

    # Duyệt qua từng sản phẩm để xử lý logic trừ số lượng
    ActiveRecord::Base.transaction do
      sanpham_details.each do |detail|
        match = detail.match(/(.+)\s(\d+)\s?(kg|thùng|bao)/)
        if match
          tensanpham = match[1].strip
          soluong_dat = match[2].to_i

          sanpham = Sanpham.find_by(ten: tensanpham)

          if sanpham.nil? || sanpham.soluong < soluong_dat
            render json: { error: "Không đủ số lượng hoặc sản phẩm '#{tensanpham}' không tồn tại!" }, status: :unprocessable_entity
            return
          end

          sanpham.update!(soluong: sanpham.soluong - soluong_dat)
        else
          render json: { error: "Dữ liệu sản phẩm không hợp lệ: '#{detail}'!" }, status: :unprocessable_entity
          return
        end
      end

      donhang.update!(trangthai: "Đã xác nhận")
    end

    render json: { message: "Đơn hàng đã được xác nhận!", id: donhang.id, trangthai: donhang.trangthai }
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end


  def vanchuyen
    donhang = Donhang.find(params[:id])

    if donhang.trangthai == "Đã xác nhận"
      donhang.update!(trangthai: "Đang vận chuyển")
      render json: { message: "Đơn hàng đang được vận chuyển!", id: donhang.id, trangthai: donhang.trangthai }
    else
      render json: { error: "Chỉ các đơn hàng đã xác nhận mới có thể vận chuyển!" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end

  def sapden
    donhang = Donhang.find(params[:id])

    if donhang.trangthai == "Đang vận chuyển"
      donhang.update!(trangthai: "Sắp đến")
      render json: { message: "Đơn hàng đã cập nhật trạng thái thành 'Sắp đến'!", id: donhang.id, trangthai: donhang.trangthai }
    else
      render json: { error: "Chỉ các đơn hàng đang vận chuyển mới có thể cập nhật thành 'Sắp đến'!" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end

  def daden
    donhang = Donhang.find(params[:id])

    if donhang.trangthai == "Sắp đến"
      donhang.update!(trangthai: "Đã đến")
      render json: { message: "Đơn hàng đã cập nhật trạng thái thành 'Đã đến'!", id: donhang.id, trangthai: donhang.trangthai }
    else
      render json: { error: "Chỉ các đơn hàng đang vận chuyển mới có thể cập nhật thành 'Đã đến'!" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end

  def cancelfinal
    donhang = Donhang.find(params[:id])

    if donhang.trangthai == "Đã huỷ"
      donhang.update!(trangthai: "Huỷ đơn hàng")
      render json: { message: "Đơn hàng đã cập nhật trạng thái thành 'Huỷ đơn hàng'!", id: donhang.id, trangthai: donhang.trangthai }
    else
      render json: { error: "Chỉ các đơn hàng đang vận chuyển mới có thể cập nhật thành 'Huỷ đơn hàng'!" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end


  def rejectcancel
    donhang = Donhang.find(params[:id])

    if donhang.trangthai == "Đã huỷ"
      donhang.update!(trangthai: "Chờ xác nhận")
      render json: { message: "Trạng thái đơn hàng đã chuyển về 'Chờ xác nhận'!", id: donhang.id, trangthai: donhang.trangthai }
    else
      render json: { error: "Chỉ đơn hàng 'Đã huỷ' mới có thể từ chối huỷ!" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: "Có lỗi xảy ra: #{e.message}" }, status: :unprocessable_entity
  end




  private

  def admin_only
    redirect_to root_path, alert: "Bạn không có quyền truy cập!" unless current_user.admin?
  end
end
