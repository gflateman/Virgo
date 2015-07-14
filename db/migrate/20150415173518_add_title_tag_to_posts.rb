class AddTitleTagToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :title_tag_text, :string
  end
end
