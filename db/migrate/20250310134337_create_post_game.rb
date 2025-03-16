class CreatePostGame < ActiveRecord::Migration[7.2]
  def change
    create_table :post_games do |t|
      t.references :post, foreign_key: true # Postのデータを関連付ける
      t.references :game, foreign_key: true # Gameのデータを関連付ける

      t.timestamps
    end
  end
end
