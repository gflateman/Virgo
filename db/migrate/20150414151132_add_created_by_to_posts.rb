class AddCreatedByToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :created_by_id, :integer
    add_index :virgo_posts, :created_by_id
    remove_column :virgo_posts, :created_by
  end
end
