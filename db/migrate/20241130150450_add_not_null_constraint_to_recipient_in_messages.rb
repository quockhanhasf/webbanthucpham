class AddNotNullConstraintToRecipientInMessages < ActiveRecord::Migration[7.2]
  def change
    change_column_null :messages, :recipient_id, false
  end
end
