class MigrateFeaturedImageToId < ActiveRecord::Migration
  def change
    remove_column :platform_posts, :featured_image, :string
    add_column :platform_posts, :featured_image_id, :integer
  end
end
