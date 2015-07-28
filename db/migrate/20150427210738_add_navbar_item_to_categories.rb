class AddNavbarItemToCategories < ActiveRecord::Migration
  def change
    add_column :virgo_categories, :display_in_navbar, :boolean
    add_index :virgo_categories, :display_in_navbar
    add_column :virgo_categories, :navbar_weight, :integer, default: 0
    add_index :virgo_categories, :navbar_weight
  end
end
