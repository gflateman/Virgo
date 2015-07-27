class AddExtraColsToSlides < ActiveRecord::Migration
  def change
    add_column :platform_slides, :title, :text
  end
end
