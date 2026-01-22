class SessionsController < ApplicationController
  def new
  end

  def create
    @taikhoan = Taikhoan.find_by(username: params[:username])

    if @taikhoan
      if @taikhoan.quyen == "Đang khoá"
        flash.now[:alert] = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên để được hỗ trợ."
        respond_to do |format|
          format.turbo_stream { render :new, status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      elsif @taikhoan.pass == params[:pass]
        session[:taikhoan_id] = @taikhoan.id
        respond_to do |format|
          format.turbo_stream { redirect_to root_path }
          format.html { redirect_to root_path }
        end
      else
        flash.now[:alert] = "Thông tin đăng nhập không chính xác."
        respond_to do |format|
          format.turbo_stream { render :new, status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    else
      flash.now[:alert] = "Thông tin đăng nhập không chính xác."
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:taikhoan_id] = nil # Xóa phiên người dùng
    redirect_to root_path, notice: "Bạn đã đăng xuất thành công." # Quay lại trang chủ với thông báo
  end
end
