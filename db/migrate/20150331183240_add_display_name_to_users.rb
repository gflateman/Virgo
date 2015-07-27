class AddDisplayNameToUsers < ActiveRecord::Migration
  def change
    add_column :platform_users, :display_name, :string
  end
end
