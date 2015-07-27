class AddPositionToPostTags < ActiveRecord::Migration
  def change
    add_column :platform_post_tags, :position, :integer, default: 0
    add_index :platform_post_tags, :position
  end
end
