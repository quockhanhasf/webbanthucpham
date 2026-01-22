class CreateSanpham < ActiveRecord::Migration[7.2]
  def change
    create_table :sanphams do |t|
      t.string :ten, null: false               # Tên sản phẩm
      t.string :loai                           # Loại sản phẩm (ví dụ: rau củ, sữa, gạo, trái cây, thịt)
      t.text :mota                             # Mô tả sản phẩm
      t.decimal :gia, precision: 10, scale: 2  # Giá sản phẩm
      t.integer :soluong                       # Số lượng sản phẩm có trong kho
      t.string :hinhanh
      t.string :donvi
      t.timestamps
    end
  end
end
