class UpdateCommentsEnabledColumnDefault < ActiveRecord::Migration
  def change
    change_column_default :posts, :comments_enabled, false
  end
end
