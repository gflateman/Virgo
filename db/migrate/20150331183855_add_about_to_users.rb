class AddAboutToUsers < ActiveRecord::Migration
  def change
    add_column :virgo_users, :about, :text
  end
end
