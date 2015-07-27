class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :platform_users, :username, :string
    add_index :platform_users, :username
  end
end
