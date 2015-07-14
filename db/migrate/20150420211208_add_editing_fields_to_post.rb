class AddEditingFieldsToPost < ActiveRecord::Migration
  def change
    add_column :platform_posts, :editing_user_id, :integer
    add_column :platform_posts, :editing_timestamp, :datetime
    add_index :platform_posts, :editing_user_id
    add_index :platform_posts, :editing_timestamp
  end
end
