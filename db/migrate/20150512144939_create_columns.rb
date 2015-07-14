class CreateColumns < ActiveRecord::Migration
  def change
    create_table :platform_columns do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :image
      t.integer :weight, default: 0
      t.timestamps
    end

    add_index :platform_columns, :weight
    add_index :platform_columns, :slug

    create_table :platform_column_posts do |t|
      t.integer :column_id
      t.integer :post_id
      t.timestamps
    end
    add_index :platform_column_posts, :column_id
    add_index :platform_column_posts, :post_id
  end
end
