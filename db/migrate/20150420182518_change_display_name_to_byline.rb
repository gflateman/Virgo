class ChangeDisplayNameToByline < ActiveRecord::Migration
  def change
    rename_column :platform_users, :display_name, :byline
  end
end
