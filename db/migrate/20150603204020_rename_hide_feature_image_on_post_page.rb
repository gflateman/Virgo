class RenameHideFeatureImageOnPostPage < ActiveRecord::Migration
  def change
    rename_column :virgo_posts, :hide_feature_image_on_post_page, :show_feature_image_on_post_page
    change_column_default :virgo_posts, :show_feature_image_on_post_page, true
  end
end
