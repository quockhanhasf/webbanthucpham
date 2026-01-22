class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= Taikhoan.find_by(id: session[:taikhoan_id]) if session[:taikhoan_id]
  end

  def authenticate_user!
    redirect_to login_path, alert: "Bạn cần đăng nhập để truy cập trang này." unless current_user
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Bạn cần đăng nhập để truy cập trang này."
    end
  end
end
