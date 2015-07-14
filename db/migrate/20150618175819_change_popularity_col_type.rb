class ChangePopularityColType < ActiveRecord::Migration
  def change
    remove_column :platform_posts, :popularity
    add_column :platform_posts, :popularity, :decimal, precision: 12, scale: 3
    add_index :platform_posts, :popularity
  end
end
