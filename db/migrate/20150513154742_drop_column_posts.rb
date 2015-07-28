class DropColumnPosts < ActiveRecord::Migration
  def change
    drop_table :virgo_column_posts
  end
end
