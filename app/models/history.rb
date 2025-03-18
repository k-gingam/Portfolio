class History < ApplicationRecord
  # Post、Userテーブルと関連
  belongs_to :user
  belongs_to :post
end
