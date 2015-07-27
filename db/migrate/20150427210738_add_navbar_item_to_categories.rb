class AddNavbarItemToCategories < ActiveRecord::Migration
  def change
    add_column :platform_categories, :display_in_navbar, :boolean
    add_index :platform_categories, :display_in_navbar
    add_column :platform_categories, :navbar_weight, :integer, default: 0
    add_index :platform_categories, :navbar_weight
  end
end
