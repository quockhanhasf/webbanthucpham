class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :taikhoan, null: false, foreign_key: { to_table: :taikhoans } # Đúng với tên bảng người dùng
      t.text :content, null: false

      t.timestamps
    end
  end
end
