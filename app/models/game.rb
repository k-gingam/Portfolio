class Game < ApplicationRecord
  # ポストが削除されたら中間テーブルpost_gamesの関連データも削除
  has_many :post_games, dependent: :destroy
  # 中間テーブルpost_gamesを通してpostsと関連
  has_many :posts, through: :post_games

  # お気に入り解除されたら中間テーブルuser_gamesの関連データも削除
  has_many :user_games, dependent: :destroy
  # 中間テーブルuser_gamesを通してusersと関連
  has_many :users, through: :user_games

  # ぶっちゃけいらないかもだけど念のためバリデーションを作成
  validates :name, presence: true, length: { maximum: 255 }

  # ポスト検索する際、検索可能なカラムの追加
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "updated_at" ]
  end
end
