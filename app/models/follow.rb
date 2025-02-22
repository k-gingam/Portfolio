class Follow < ApplicationRecord
  # Userテーブルと関連、今回は「User多」対「User多」関係の為、クラス名を宣言することで別々の関連付けを行う
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"
end
