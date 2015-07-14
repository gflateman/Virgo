class AddDisableFeatureImageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :hide_feature_image_on_post_page, :boolean, default: false
  end
end
