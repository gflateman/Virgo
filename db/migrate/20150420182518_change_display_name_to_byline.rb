class ChangeDisplayNameToByline < ActiveRecord::Migration
  def change
    rename_column :virgo_users, :display_name, :byline
  end
end
