class AddColumnIdToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :column_id, :integer
    add_index :virgo_posts, :column_id
  end
end
