class User < ApplicationRecord
  authenticates_with_sorcery!

  # ポストと関連付け、このユーザーが削除されたらポストも削除
  has_many :posts, dependent: :destroy

  # お気に入り解除されたら中間テーブルuser_gamesの関連データも削除
  has_many :user_games, dependent: :destroy
  # 中間テーブルuser_gamesを通してgamesと関連
  has_many :games, through: :user_games

  # ポストが削除されたら中間テーブルHistoriesの関連データも削除
  has_many :histories, dependent: :destroy

  # 中間テーブルFollowとの関連付け、「User多」対「User多」の関係となるがクラス名を宣言することで別々の関連付けの宣言にする
  has_many :following, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :follower, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy

  # 誰が誰をフォローしているのかデータを取得する
  has_many :following_user, through: :following, source: :follower
  has_many :follower_user, through: :follower, source: :following

  # パスワード入力用
  # 新規ユーザー登録、パスワード変更の際に入力されたパスワードが正しいか
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # 名前とメールアドレス用
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  # パスワードリセット際のトークン設定
  validates :reset_password_token, uniqueness: true, allow_nil: true

  # アイコンの保存設定
  mount_uploader :icon, AvatarUploader

  # 自己紹介のテキスト設定
  validates :introduction, length: { maximum: 140 }

  # ログインしているユーザーのフォロー処理
  def follow(user_id)
    following.create(follower_id: user_id)
  end
  # ログインしているユーザーのフォロー外し処理
  def unfollow(user_id)
    following.find_by(follower_id: user_id).destroy
  end
  # ログインしているユーザーがプロフィール画面のユーザーをフォローしているか確認
  def following?(user)
    following_user.include?(user)
  end

  # ゲームのお気に入り登録処理
  def game_bookmark(game_id, user_id)
    UserGame.create(game_id: game_id, user_id: user_id)
  end
  def game_unbookmark(game_id, user_id)
    UserGame.find_by(game_id: game_id, user_id: user_id).destroy
  end
  def game_bookmark?(game_id, user_id)
    UserGame.exists?(game_id: game_id, user_id: user_id)
  end
end
