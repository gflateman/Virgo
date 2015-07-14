class FixPageModuleSubjectTypeColumn < ActiveRecord::Migration
  def change
    remove_column :platform_page_modules, :subject_type

    add_column :platform_page_modules, :subject_type, :string
    add_index :platform_page_modules, :subject_type
  end
end
