class UserGame < ApplicationRecord
  # User、Gameテーブルと関連
  belongs_to :user
  belongs_to :game
end
