class AddNameToSites < ActiveRecord::Migration
  def change
    add_column :virgo_sites, :name, :text
  end
end
