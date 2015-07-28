class AddAltTextToImages < ActiveRecord::Migration
  def change
    add_column :virgo_images, :alt_text, :text
    add_column :virgo_images, :description, :text
  end
end
