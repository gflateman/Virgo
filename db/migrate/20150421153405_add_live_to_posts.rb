class AddLiveToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :live, :boolean, default: true
    add_index :platform_posts, :live
  end
end
