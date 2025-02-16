class CreateHistory < ActiveRecord::Migration[7.2]
  def change
    create_table :histories do |t|
      t.references :user, foreign_key: true # Userのデータを関連付ける
      t.references :post, foreign_key: true # Postのデータを関連付ける

      t.timestamps
    end
  end
end
