class AddCommentsEnabledToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :comments_enabled, :boolean, default: true
  end
end
