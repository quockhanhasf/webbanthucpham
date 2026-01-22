class ChangeSoluongTypeInDonhangs < ActiveRecord::Migration[7.2]
  def change
    change_column :donhangs, :soluong, :integer
  end
end
