class AddCommentsEnabledToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :comments_enabled, :boolean, default: true
  end
end
