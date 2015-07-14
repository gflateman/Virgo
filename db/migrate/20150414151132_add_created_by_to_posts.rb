class AddCreatedByToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :created_by_id, :integer
    add_index :platform_posts, :created_by_id
    remove_column :platform_posts, :created_by
  end
end
