class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :virgo_slideshows do |t|
      t.integer :author_id
      t.string :name
      t.timestamps
    end
    add_index :virgo_slideshows, :author_id

    rename_column :virgo_slides, :post_id, :slideshow_id
  end
end
