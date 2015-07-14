class AddVisibleToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :visible, :boolean, default: true
    add_index :categories, :visible

    Category.COLUMNS.update!(visible: false) if Category.COLUMNS
  end
end
