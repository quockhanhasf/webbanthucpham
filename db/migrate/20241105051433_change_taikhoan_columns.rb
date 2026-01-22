class ChangeTaikhoanColumns < ActiveRecord::Migration[7.2]
  def change
    # Remove the old columns
    remove_column :taikhoans, :matk, :integer
    remove_column :taikhoans, :role, :string

    # Add the new columns
    add_column :taikhoans, :email, :string
    add_column :taikhoans, :hoten, :string
    add_column :taikhoans, :ngaysinh, :date
    add_column :taikhoans, :diachi, :string
    add_column :taikhoans, :sdt, :string
    add_column :taikhoans, :quyen, :string
  end
end
