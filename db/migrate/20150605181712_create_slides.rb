class CreateSlides < ActiveRecord::Migration
  def change
    create_table :platform_slides do |t|
      t.string :image
      t.text :text
      t.integer :post_id
      t.integer :position
      t.timestamps
    end

    add_index :platform_slides, :post_id
    add_index :platform_slides, :position
  end
end
