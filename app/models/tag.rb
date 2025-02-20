class Tag < ApplicationRecord
  # ポストが削除されたら中間テーブルpost_tagsの関連データも削除
  has_many :post_tags, dependent: :destroy
  # 中間テーブルpost_tagsを通してpostsと関連
  has_many :posts, through: :post_tags

  # ぶっちゃけいらないかもだけど念のためバリデーションを作成
  validates :name, presence: true, length: { maximum: 255 }

  # ポスト検索する際、検索可能なカラムの追加
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "name", "updated_at" ]
  end
end
