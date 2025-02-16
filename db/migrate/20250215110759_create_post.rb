class CreatePost < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true # ポストの投稿者、usersから取得
      t.string :movie_url, null: false # 動画のURL
      t.string :comment, null: false # ポストのコメント内容
      t.integer :view_count, default: 0 # ポストの閲覧回数

      t.timestamps # 作成日時のデータだけ使う
    end
  end
end
