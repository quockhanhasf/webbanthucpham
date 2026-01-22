class CreateDonhangs < ActiveRecord::Migration[7.2]
  def change
    create_table :donhangs do |t|
      t.string :hoten
      t.string :sdt
      t.string :email
      t.text :diachi
      t.string :tensanpham
      t.integer :soluong
      t.string :trangthaithanhtoan # Đổi lại thành string cho trạng thái thanh toán
      t.integer :tongthanhtoan # Đổi lại thành integer cho tổng thanh toán
      t.datetime :ngaydathang
      t.timestamps
    end
  end
end
