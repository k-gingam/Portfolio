class Post < ApplicationRecord
  # Userテーブルと関連
  belongs_to :user
  # ポストが削除されたら中間テーブルpost_tagsの関連データも削除
  has_many :post_tags, dependent: :destroy
  # 中間テーブルpost_tagsを通してtagsと関連
  has_many :tags, through: :post_tags

  # 動画URL、コメントのモデル設定
  validates :movie_url, presence: true, length: { maximum: 255 }
  validates :comment, presence: true, length: { maximum: 255 }

  # カスタムバリデーションの設定、正しくURL入力されてるかチェック
  validate :url_check

  def url_check
    # 正しいURLで入力されているかどうか、一応ライブ動画も対応
    if !movie_url.start_with?("https://youtu.be/") && !movie_url.start_with?("https://www.youtube.com/live/")
      errors.add(:movie_url, "正しい入力ではありません") # save失敗のためにerror文、メッセージ対応は後で
    end
  end

  # タグ保存用のメソッド(Toxi法と呼ぶらしい)
  def save_tags(tag_names)
    tag_names.each do |tagname|
      # テーブルTagに保存、タグが重複があれば保存しない
      post_tag = Tag.find_or_create_by(name: tagname)
      # 中間テーブルPost_Tagに保存、こちらも重複があれば保存しない
      self.tags << post_tag

      # if !self.tags.find_by(name: post_tag.name)
      #   self.tags << post_tag
      # end
    end
  end

  # ポスト検索する際、検索可能なカラムの追加
  def self.ransackable_attributes(auth_object = nil)
    [ "comment", "created_at", "id", "movie_url", "updated_at", "user_id", "view_count" ]
  end
  # ポスト検索する際、検索可能なテーブルの追加
  def self.ransackable_associations(auth_object = nil)
    [ "post_tags", "tags", "user" ]
  end
end
