class AddImageToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :image, :string
  end
end
