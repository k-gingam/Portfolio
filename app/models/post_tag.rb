class PostTag < ApplicationRecord
  # Post、Tagテーブルと関連
  belongs_to :post
  belongs_to :tag
end
