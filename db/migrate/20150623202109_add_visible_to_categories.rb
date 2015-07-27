class AddVisibleToCategories < ActiveRecord::Migration
  def change
    add_column :platform_categories, :visible, :boolean, default: true
    add_index :platform_categories, :visible
  end
end
