class AddColumnIdToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :column_id, :integer
    add_index :platform_posts, :column_id
  end
end
