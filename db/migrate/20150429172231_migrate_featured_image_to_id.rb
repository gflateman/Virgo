class MigrateFeaturedImageToId < ActiveRecord::Migration
  def change
    remove_column :virgo_posts, :featured_image, :string
    add_column :virgo_posts, :featured_image_id, :integer
  end
end
