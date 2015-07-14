class AddThumbnailIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :thumbnail_image_id, :integer
    add_index :posts, :thumbnail_image_id
  end
end
