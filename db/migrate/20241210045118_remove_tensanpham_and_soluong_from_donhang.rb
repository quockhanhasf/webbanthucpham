class RemoveTensanphamAndSoluongFromDonhang < ActiveRecord::Migration[7.2]
  def change
    remove_column :donhangs, :tensanpham, :string
    remove_column :donhangs, :soluong, :integer
    add_column :donhangs, :thongtinsanpham, :string
  end
end
