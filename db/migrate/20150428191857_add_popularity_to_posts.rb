class AddPopularityToPosts < ActiveRecord::Migration
  def change
    add_column :virgo_posts, :popularity, :integer, default: 0
    add_index :virgo_posts, :popularity
  end
end
