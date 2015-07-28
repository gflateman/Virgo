class AddDescriptionToSite < ActiveRecord::Migration
  def change
    add_column :virgo_sites, :description, :text
  end
end
