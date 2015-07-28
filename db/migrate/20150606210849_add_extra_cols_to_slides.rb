class AddExtraColsToSlides < ActiveRecord::Migration
  def change
    add_column :virgo_slides, :title, :text
  end
end
