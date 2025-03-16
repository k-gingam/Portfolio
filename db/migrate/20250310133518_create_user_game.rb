class CreateUserGame < ActiveRecord::Migration[7.2]
  def change
    create_table :user_games do |t|
      t.references :user, foreign_key: true # Userのデータを関連付ける
      t.references :game, foreign_key: true # Gameのデータを関連付ける

      t.timestamps
    end
  end
end
