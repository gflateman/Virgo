class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :platform_users, :slug, :string
    add_index :platform_users, :slug
  end
end
