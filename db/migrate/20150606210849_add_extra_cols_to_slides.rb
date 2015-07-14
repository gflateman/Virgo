class AddExtraColsToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :title, :text
  end
end
