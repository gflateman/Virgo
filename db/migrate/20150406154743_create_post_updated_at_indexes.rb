class CreatePostUpdatedAtIndexes < ActiveRecord::Migration
  def change
    add_index :platform_posts, :updated_at, order: {created_at: :desc}
  end
end
