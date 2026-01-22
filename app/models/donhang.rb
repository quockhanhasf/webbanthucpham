# app/models/donhang.rb
class Donhang < ApplicationRecord
  has_many :sanpham, through: :donhang_sanpham # Giả sử có bảng nối hoặc có thể tìm qua tên
  # Validation cho các trường cần thiết
  validates :hoten, :sdt, :email, :diachi, :trangthaithanhtoan, :tongthanhtoan, :ngaydathang, :trangthai,  presence: true
  validates :tongthanhtoan, numericality: { greater_than: 0 }
end
