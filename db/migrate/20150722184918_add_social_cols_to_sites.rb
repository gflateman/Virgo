class AddSocialColsToSites < ActiveRecord::Migration
  def change
    add_column :platform_sites, :twitter_handle, :string
    add_column :platform_sites, :instagram_account_name, :string
    add_column :platform_sites, :pinterest_account_name, :string
  end
end
