class UpdateCommentsEnabledColumnDefault < ActiveRecord::Migration
  def change
    change_column_default :platform_posts, :comments_enabled, false
  end
end
