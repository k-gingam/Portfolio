class AddUsernameDefault < ActiveRecord::Migration[7.2]
  def change
    # テストコード実行の際、User.nameがnilの時の対策としてデフォルト値を設定
    change_column_default :users, :name, from: nil, to: "Name"
    change_column_default :users, :email, from: nil, to: "test@example.com"
  end
end
