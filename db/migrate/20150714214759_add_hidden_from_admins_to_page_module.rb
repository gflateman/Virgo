class AddHiddenFromAdminsToPageModule < ActiveRecord::Migration
  def change
    unless column_exists?(:platform_page_modules, :hidden_from_admins)
      add_column :platform_page_modules, :hidden_from_admins, :boolean, default: false
    end
  end
end
