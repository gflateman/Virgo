class ChangePopularityColType < ActiveRecord::Migration
  def change
    remove_column :virgo_posts, :popularity
    add_column :virgo_posts, :popularity, :decimal, precision: 12, scale: 3
    add_index :virgo_posts, :popularity
  end
end
