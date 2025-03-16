class CreateGame < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :name # ゲーム名
      t.string :icon # ゲームアイコン

      t.timestamps
    end
  end
end
