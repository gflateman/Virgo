class AddHiddenFromAdminsToPageModule < ActiveRecord::Migration
  def change
    add_column :platform_page_modules, :hidden_from_admins, :boolean, default: false
  end
end
