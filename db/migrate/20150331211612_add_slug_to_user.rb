class AddSlugToUser < ActiveRecord::Migration
  def change
    add_column :virgo_users, :slug, :string
    add_index :virgo_users, :slug
  end
end
