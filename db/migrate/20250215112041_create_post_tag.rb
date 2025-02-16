class CreatePostTag < ActiveRecord::Migration[7.2]
  def change
    create_table :post_tags do |t|
      t.references :post, foreign_key: true # Postのデータを関連付ける
      t.references :tag, foreign_key: true # Tagのデータを関連付ける

      t.timestamps
    end
  end
end
