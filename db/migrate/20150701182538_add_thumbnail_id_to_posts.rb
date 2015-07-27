class AddThumbnailIdToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :thumbnail_image_id, :integer
    add_index :platform_posts, :thumbnail_image_id
  end
end
