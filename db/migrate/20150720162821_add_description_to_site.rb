class AddDescriptionToSite < ActiveRecord::Migration
  def change
    add_column :platform_sites, :description, :text
  end
end
