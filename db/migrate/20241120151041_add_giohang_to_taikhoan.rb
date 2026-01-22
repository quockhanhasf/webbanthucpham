class AddGiohangToTaikhoan < ActiveRecord::Migration[7.2]
  def change
    add_column :taikhoans, :giohang, :text
  end
end
