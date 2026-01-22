class AddQuyenToTaikhoan < ActiveRecord::Migration[7.2]
  def change
    add_column :taikhoans, :quyen, :string
  end
end
