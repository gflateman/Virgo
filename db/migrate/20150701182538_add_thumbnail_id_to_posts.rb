class AddThumbnailIdToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :thumbnail_image_id, :integer
    add_index :virgo_posts, :thumbnail_image_id
  end
end
