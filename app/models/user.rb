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
end
