class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :image
      t.text :text
      t.integer :post_id
      t.integer :position
      t.timestamps
    end

    add_index :slides, :post_id
    add_index :slides, :position
  end
end