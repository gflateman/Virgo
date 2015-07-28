class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :virgo_users, :username, :string
    add_index :virgo_users, :username
  end
end
