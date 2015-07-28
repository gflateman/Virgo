class AddCreditToImages < ActiveRecord::Migration
  def change
    add_column :virgo_images, :credit, :text
  end
end
