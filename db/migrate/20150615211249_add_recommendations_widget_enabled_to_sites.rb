class AddRecommendationsWidgetEnabledToSites < ActiveRecord::Migration
  def change
    add_column :virgo_sites, :recommendations_enabled, :boolean, default: true
  end
end
