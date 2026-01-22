class GiaidoanController < ApplicationController
  before_action :authenticate_user!

  def index
    # Lọc đơn hàng theo tên người dùng và loại trừ các đơn hàng có trạng thái 'Đã nhận'
    @donhangs = Donhang.where(hoten: current_user.hoten).where.not(trangthai: [ "Đã nhận", "Huỷ đơn hàng" ])


    # Đếm số lượng đơn hàng
    @giaohang_count = @donhangs.size
  end

  def lichsu
    @donhangs = Donhang.where(hoten: current_user.hoten, trangthai: [ "Đã nhận", "Huỷ đơn hàng" ])
  end

  def show
    # Bao gồm thông tin liên kết giữa đơn hàng và sản phẩm (nếu có quan hệ)
    @donhangs = Donhang.includes(:sanpham)
  end

  # Phương thức cập nhật trạng thái đơn hàng
  def update_trangthai
    @donhang = Donhang.find_by(id: params[:id])  # Dùng `find_by` để tránh lỗi nếu không tìm thấy ID

    if @donhang.nil?
      render json: { success: false, message: "Đơn hàng không tồn tại." }, status: :not_found
    elsif @donhang.update(trangthai: params[:trangthai])
      render json: { success: true, message: "Trạng thái đơn hàng đã được cập nhật." }, status: :ok
    else
      render json: { success: false, message: "Không thể cập nhật trạng thái." }, status: :unprocessable_entity
    end
  end

  def huydonhang
    @donhang = Donhang.find(params[:id])

    if @donhang.update(trangthai: "Đã huỷ")
      render json: { message: "Đơn hàng đã được huỷ." }, status: :ok
    else
      render json: { error: "Không thể huỷ đơn hàng." }, status: :unprocessable_entity
    end
  end

  def capnhat
    donhang = Donhang.find(params[:id])

    # Xử lý dữ liệu từ form
    xa = params[:ward]
    huyen = params[:district]
    tinh = params[:province]
    diachi_cuthe = params[:address]
    diachi_day_du = "#{diachi_cuthe}, #{xa}, #{huyen}, #{tinh}"

    # Cập nhật thông tin
    if donhang.update(
      sdt: params[:sdt],
      email: params[:email],
      diachi: diachi_day_du
    )
      render json: { success: true }
    else
      render json: { success: false, errors: donhang.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private

  def donhang_params
    params.require(:donhang).permit(:hoten, :sdt, :diachi, :email)
  end
end
