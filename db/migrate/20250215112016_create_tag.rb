class CreateTag < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.string :name # タグの名前
      t.timestamps
    end
  end
end
