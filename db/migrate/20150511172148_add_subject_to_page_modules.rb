class AddSubjectToPageModules < ActiveRecord::Migration
  def change
    add_column :platform_page_modules, :subject_id, :integer
    add_column :platform_page_modules, :subject_type, :integer
    add_index :platform_page_modules, :subject_id
    add_index :platform_page_modules, :subject_type
  end
end
