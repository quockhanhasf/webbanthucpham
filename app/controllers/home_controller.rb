class HomeController < ApplicationController
  before_action :set_unread_message_count

  def index
    @page_title = "Trang chủ"
    @user = current_user
    # sử bạn có logic để tính số lượng tin nhắn chưa đọc
  end

  private

  def set_unread_message_count
    return unless current_user # Kiểm tra nếu người dùng đã đăng nhập

    if current_user.quyen == "admin"
      # Đếm số tin nhắn chưa đọc từ các user gửi đến admin
      @unread_message_count = Message.where(recipient_id: current_user.id, read: false).count
    else
      # Đếm số tin nhắn chưa đọc từ admin gửi đến user
      admin = Taikhoan.find_by(quyen: "admin")
      @unread_message_count = Message.where(recipient_id: current_user.id, taikhoan_id: admin.id, read: false).count

      # Đánh dấu tất cả tin nhắn từ admin đã đọc khi người dùng truy cập trang chat với admin
      Message.where(recipient_id: current_user.id, taikhoan_id: admin.id, read: false).update_all(read: true)
    end
  end
end
