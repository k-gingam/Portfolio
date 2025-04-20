class AddUserActivation < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :after_change_email, :string, default: nil
  end
end
