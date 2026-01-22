class AddEmailToDonhang < ActiveRecord::Migration[7.2]
  def change
    add_column :donhangs, :email, :string
  end
end
