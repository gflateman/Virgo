class AddDisqusAppIdToSites < ActiveRecord::Migration
  def change
    add_column :virgo_sites, :disqus_app_id, :string
  end
end
