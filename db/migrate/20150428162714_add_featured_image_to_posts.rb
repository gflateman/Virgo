class AddFeaturedImageToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :featured_image, :string
  end
end
