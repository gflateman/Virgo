class AddNameToSites < ActiveRecord::Migration
  def change
    add_column :platform_sites, :name, :text
  end
end
