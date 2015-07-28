class AddVisibleToCategories < ActiveRecord::Migration
  def change
    add_column :virgo_categories, :visible, :boolean, default: true
    add_index :virgo_categories, :visible
  end
end
