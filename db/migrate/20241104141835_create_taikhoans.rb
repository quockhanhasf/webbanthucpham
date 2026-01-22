class CreateTaikhoans < ActiveRecord::Migration[7.2]
  def change
    create_table :taikhoans do |t|
      t.string :matk
      t.string :username
      t.string :pass
      t.string :role

      t.timestamps
    end
  end
end
