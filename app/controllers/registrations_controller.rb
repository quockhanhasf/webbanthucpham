# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  def create
    @user = Taikhoan.new(user_params)


    if @user.valid?
      @verification_code = rand(100000..999999).to_s
      session[:verification_code] = @verification_code
      session[:user_data] = user_params
      UserMailer.verification_email(@user, @verification_code).deliver_now
      render json: { message: "Đã gửi email xác nhận!" }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def verify_code
    if params[:code] == session[:verification_code]
      user_data = session[:user_data]
      @user = Taikhoan.new(user_data)
      if @user.save
        session.delete(:verification_code)
        session.delete(:user_data)
        render json: { message: "Đăng kí thành công!" }
      else
        render json: { error: "Có lỗi xảy ra khi tạo tài khoản" }
      end
    else
      render json: { error: "Mã xác nhận không hợp lệ" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :pass, :email, :hoten).merge(quyen: "user")
  end
end
