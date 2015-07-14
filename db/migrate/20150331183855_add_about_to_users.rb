class AddAboutToUsers < ActiveRecord::Migration
  def change
    add_column :platform_users, :about, :text
  end
end
