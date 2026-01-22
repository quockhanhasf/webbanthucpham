class DonhangsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Tạo đối tượng Donhang với tham số từ params
    @donhang = Donhang.new(donhang_params)

    if @donhang.save
      render json: { message: "Đặt hàng thành côngh!", donhang: @donhang }, status: :created
    else
      render json: @donhang.errors.full_messages, status: :unprocessable_entity
    end
  end



  private

  def donhang_params
    params.require(:donhang).permit(
      :hoten, :sdt, :email, :diachi, :trangthaithanhtoan, :tongthanhtoan,
      :ngaydathang, :trangthai, :thongtinsanpham
    )
  end
end
