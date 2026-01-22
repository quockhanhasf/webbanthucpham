class AddRecipientToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :recipient, foreign_key: { to_table: :taikhoans }
  end
end
