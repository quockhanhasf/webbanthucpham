class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update ]

  def show
    # Hiển thị thông tin người dùng
  end

  def update
    if params[:taikhoan] && params[:taikhoan][:avatar_url]
      uploaded_file = params[:taikhoan][:avatar_url]
      file_name = "#{SecureRandom.hex(10)}_#{uploaded_file.original_filename}"
      file_path = Rails.root.join("public", "uploads", file_name)

      # Lưu tệp vào thư mục `public/uploads`
      File.open(file_path, "wb") do |file|
        file.write(uploaded_file.read)
      end

      # Cập nhật thuộc tính avatar_url trong cơ sở dữ liệu
      @user.avatar_url = "/uploads/#{file_name}"
    end

    # Cập nhật các thuộc tính khác
    if @user.update(user_update_params.except(:avatar_url))
      render json: { success: true, message: "Cập nhật thành công!", avatar_url: @user.avatar_url }
    else
      render json: { success: false, message: @user.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Taikhoan.find(params[:id])
  end

  def user_update_params
    params.require(:taikhoan).permit(:hoten, :ngaysinh, :sdt, :diachi, :avatar_url)
  end
end
