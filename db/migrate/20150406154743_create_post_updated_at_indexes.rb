class CreatePostUpdatedAtIndexes < ActiveRecord::Migration
  def change
    add_index :virgo_posts, :updated_at, order: {created_at: :desc}
  end
end
