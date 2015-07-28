class FixPageModuleSubjectTypeColumn < ActiveRecord::Migration
  def change
    remove_column :virgo_page_modules, :subject_type

    add_column :virgo_page_modules, :subject_type, :string
    add_index :virgo_page_modules, :subject_type
  end
end
