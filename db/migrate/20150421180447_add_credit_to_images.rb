class AddCreditToImages < ActiveRecord::Migration
  def change
    add_column :platform_images, :credit, :text
  end
end
