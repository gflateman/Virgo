class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :slideshows do |t|
      t.integer :author_id
      t.string :name
      t.timestamps
    end
    add_index :slideshows, :author_id

    rename_column :slides, :post_id, :slideshow_id
  end
end
