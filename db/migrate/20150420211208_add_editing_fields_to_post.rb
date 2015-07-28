class AddEditingFieldsToPost < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :editing_user_id, :integer
    add_column :virgo_posts, :editing_timestamp, :datetime
    add_index :virgo_posts, :editing_user_id
    add_index :virgo_posts, :editing_timestamp
  end
end
