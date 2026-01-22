class PasswordsController < ApplicationController
  def forgot_password
    username = params[:username]
    email = params[:email]

    # Kiểm tra đầu vào
    if username.blank? || email.blank?
      render json: { error: "Vui lòng điền đầy đủ tài khoản và email!" }, status: :unprocessable_entity
      return
    end

    # Tìm tài khoản
    user = Taikhoan.find_by(username: username, email: email)
    if user.nil?
      render json: { error: "Tài khoản hoặc email không đúng!" }, status: :unprocessable_entity
      return
    end

    # Sinh mã xác nhận
    verification_code = rand(100000..999999).to_s
    session[:verification_code] = verification_code
    session[:username] = username

    # Gửi mã xác nhận qua email
    UserMailer.password_reset_email(user, verification_code).deliver_now

    render json: { message: "Đã gửi mã xác nhận đến email của bạn." }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def verify_forgot_code
    code = params[:code]
    username = session[:username]

    if code.blank? || username.blank?
      render json: { error: "Mã xác nhận hoặc phiên làm việc không hợp lệ!" }, status: :unprocessable_entity
      return
    end

    # Kiểm tra mã xác nhận
    if session[:verification_code] != code
      render json: { error: "Mã xác nhận không đúng!" }, status: :unprocessable_entity
      return
    end

    # Mã xác nhận đúng -> cho phép hiển thị form đặt lại mật khẩu
    render json: { message: "Mã xác nhận đúng! Bạn có thể đặt lại mật khẩu." }, status: :ok
  end


  def reset_password
    new_password = params[:password]
    username = session[:username]

    if new_password.blank?
      render json: { error: "Mật khẩu không được để trống!" }, status: :unprocessable_entity
      return
    end

    # Cập nhật mật khẩu
    user = Taikhoan.find_by(username: username)
    if user
      user.update(pass: new_password)
      session.delete(:verification_code) # Xóa mã xác nhận sau khi sử dụng
      session.delete(:username)          # Xóa phiên làm việc
      render json: { message: "Mật khẩu đã được cập nhật!" }, status: :ok
    else
      render json: { error: "Không tìm thấy tài khoản!" }, status: :not_found
    end
  end
end
