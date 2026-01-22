class Taikhoan < ApplicationRecord
  before_create :set_default_avatar_url
  has_many :sent_messages, class_name: "Message", foreign_key: "taikhoan_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", dependent: :destroy

  def admin?
    quyen == "admin"
  end

  private

  def set_default_avatar_url
    self.avatar_url ||= Rails.root.join("app/assets/images/th.jpg").to_s # Đặt đường dẫn mặc định
  end
end
