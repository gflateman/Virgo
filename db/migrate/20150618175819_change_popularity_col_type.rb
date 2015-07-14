class ChangePopularityColType < ActiveRecord::Migration
  def change
    remove_column :posts, :popularity
    add_column :posts, :popularity, :decimal, precision: 12, scale: 3
    add_index :posts, :popularity
  end
end
