class AddAvatarUrlToTaikhoan < ActiveRecord::Migration[7.2]
  def change
    add_column :taikhoans, :avatar_url, :string
  end
end
