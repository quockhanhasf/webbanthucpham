# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def verification_email(user, code)
    @user = user
    @code = code

    # Thiết lập nội dung email trực tiếp
    mail(
      to: @user.email,
      subject: "Mã xác nhận đăng ký tài khoản"
    ) do |format|
      format.text { render plain: "Xin chào #{@user.username},\n\nCảm ơn bạn đã đăng ký tài khoản! Đây là mã xác nhận của bạn: #{@code}\n\nVui lòng nhập mã này trong trang đăng ký để hoàn tất quá trình tạo tài khoản." }
    end
  end

  def password_reset_email(user, code)
    @user = user
    @code = code

    mail(
      to: @user.email,
      subject: "Mã xác nhận đặt lại mật khẩu"
    ) do |format|
      format.text { render plain: "Xin chào #{@user.username},\n\nĐây là mã xác nhận đặt lại mật khẩu của bạn: #{@code}\n\nVui lòng nhập mã này để tiếp tục." }
    end
  end
end
