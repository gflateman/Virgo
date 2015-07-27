class AddAltTextToImages < ActiveRecord::Migration
  def change
    add_column :platform_images, :alt_text, :text
    add_column :platform_images, :description, :text
  end
end
