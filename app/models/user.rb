class User < ApplicationRecord
  authenticates_with_sorcery!

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
end
