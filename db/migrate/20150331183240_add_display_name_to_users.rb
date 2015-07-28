class AddDisplayNameToUsers < ActiveRecord::Migration
  def change
    add_column :virgo_users, :display_name, :string
  end
end
