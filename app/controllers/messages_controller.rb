class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    if @user.quyen == "admin"
      # Lấy danh sách người dùng có tin nhắn
      @users = Taikhoan.joins(:sent_messages)
                       .where(messages: { recipient_id: @user.id })
                       .distinct

      # Tạo danh sách số lượng tin nhắn chưa đọc
      @unread_counts = @users.each_with_object({}) do |user, counts|
        counts[user.id] = Message.where(taikhoan_id: user.id, recipient_id: @user.id, read: false).count
      end

      # Lấy tin nhắn của user được chọn
      @selected_user = Taikhoan.find_by(id: params[:user_id])
      if @selected_user
        @messages = Message.where(taikhoan_id: @selected_user.id, recipient_id: @user.id)
                           .or(Message.where(taikhoan_id: @user.id, recipient_id: @selected_user.id))
                           .order(created_at: :asc)

        # Đánh dấu tin nhắn của user được chọn là đã đọc
        Message.where(taikhoan_id: @selected_user.id, recipient_id: @user.id, read: false).update_all(read: true)
      else
        @messages = []
      end
    else
      # Hiển thị tin nhắn giữa user hiện tại và admin
      admin = Taikhoan.find_by(quyen: "admin")
      @messages = Message.where(taikhoan_id: @user.id, recipient_id: admin.id)
                         .or(Message.where(taikhoan_id: admin.id, recipient_id: @user.id))
                         .order(created_at: :asc)
    end
    @message = Message.new
  end

  def create
    recipient = params[:recipient_id] ? Taikhoan.find(params[:recipient_id]) : Taikhoan.find_by(quyen: "admin")
    @message = current_user.sent_messages.build(message_params.merge(recipient_id: recipient.id))

    if @message.save
      redirect_to messages_path(user_id: recipient.id), notice: "Tin nhắn đã được gửi!"
    else
      redirect_to messages_path(user_id: recipient.id), alert: "Có lỗi xảy ra khi gửi tin nhắn."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :image)
  end
end
