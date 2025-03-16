class PostGame < ApplicationRecord
  # Post、Gameテーブルと関連
  belongs_to :post
  belongs_to :game
end
