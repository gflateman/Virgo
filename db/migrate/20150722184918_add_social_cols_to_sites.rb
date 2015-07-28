class AddSocialColsToSites < ActiveRecord::Migration
  def change
    add_column :virgo_sites, :twitter_handle, :string
    add_column :virgo_sites, :instagram_account_name, :string
    add_column :virgo_sites, :pinterest_account_name, :string
  end
end
