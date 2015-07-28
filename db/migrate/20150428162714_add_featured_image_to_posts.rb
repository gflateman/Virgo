class AddFeaturedImageToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :featured_image, :string
  end
end
