class DropColumnPosts < ActiveRecord::Migration
  def change
    drop_table :platform_column_posts
  end
end
