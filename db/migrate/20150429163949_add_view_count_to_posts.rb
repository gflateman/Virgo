class AddViewCountToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :view_count, :integer, default: 0
    add_index :platform_posts, :view_count
  end
end
