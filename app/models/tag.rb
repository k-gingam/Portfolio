class Tag < ApplicationRecord
  # ポストが削除されたら中間テーブルpost_tagsの関連データも削除
  has_many :post_tags, dependent: :destroy
  # 中間テーブルpost_tagsを通してpostsと関連
  has_many :posts, through: :post_tags

  # ぶっちゃけいらないかもだけど念のためバリデーションを作成
  validates :name, presence: true, length: { maximum: 255 }
end
