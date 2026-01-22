class AddGianhapToSanpham < ActiveRecord::Migration[7.2]
  def change
    add_column :sanphams, :gianhap, :decimal
  end
end
