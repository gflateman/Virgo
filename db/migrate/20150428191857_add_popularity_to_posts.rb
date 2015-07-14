class AddPopularityToPosts < ActiveRecord::Migration
  def change
    add_column :platform_posts, :popularity, :integer, default: 0
    add_index :platform_posts, :popularity
  end
end
