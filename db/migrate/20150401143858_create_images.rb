class CreateImages < ActiveRecord::Migration
  def change
    create_table :virgo_images do |t|
      t.integer :user_id
      t.string :name
      t.string :slug
      t.string :image
      t.integer :width
      t.integer :height
      t.text :data_file_name
      t.text :data_content_type
      t.integer :data_file_size
      t.timestamps
    end
    add_index :virgo_images, :user_id
    add_index :virgo_images, :name
    add_index :virgo_images, :slug
  end
end
