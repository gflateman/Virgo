class AddViewCountToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :view_count, :integer, default: 0
    add_index :virgo_posts, :view_count
  end
end
