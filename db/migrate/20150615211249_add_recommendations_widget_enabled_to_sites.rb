class AddRecommendationsWidgetEnabledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :recommendations_enabled, :boolean, default: true
  end
end
