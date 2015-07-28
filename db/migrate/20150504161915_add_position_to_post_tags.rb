class AddPositionToPostTags < ActiveRecord::Migration
  def change
    add_column :virgo_post_tags, :position, :integer, default: 0
    add_index :virgo_post_tags, :position
  end
end
