class AddTitleTagToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :title_tag_text, :string
  end
end
