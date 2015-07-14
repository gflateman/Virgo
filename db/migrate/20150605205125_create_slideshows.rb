class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :platform_slideshows do |t|
      t.integer :author_id
      t.string :name
      t.timestamps
    end
    add_index :platform_slideshows, :author_id

    rename_column :platform_slides, :post_id, :slideshow_id
  end
end
