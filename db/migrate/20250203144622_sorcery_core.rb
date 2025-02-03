class SorceryCore < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :icon            #プロフィール画像、ファイルサーバを用意しているので使わないかも
      t.text :introduction      #自己紹介用テキスト
      t.string :favorite_game   #お気に入りのゲーム
      t.string :google_account  #Googleアカウント連携用、場合によっては使わないかも

      t.timestamps                null: false
    end
  end
end
