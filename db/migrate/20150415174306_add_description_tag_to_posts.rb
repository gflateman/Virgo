class AddDescriptionTagToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :meta_description_tag_value, :text
  end
end
