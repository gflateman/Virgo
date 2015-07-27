class AddDisqusAppIdToSites < ActiveRecord::Migration
  def change
    add_column :platform_sites, :disqus_app_id, :string
  end
end
