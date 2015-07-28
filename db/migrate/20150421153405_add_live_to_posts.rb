class AddLiveToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :live, :boolean, default: true
    add_index :virgo_posts, :live
  end
end
