class AddDisableFeatureImageToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :hide_feature_image_on_post_page, :boolean, default: false
  end
end
