class AddSubjectToPageModules < ActiveRecord::Migration
  def change
    add_column :virgo_page_modules, :subject_id, :integer
    add_column :virgo_page_modules, :subject_type, :integer
    add_index :virgo_page_modules, :subject_id
    add_index :virgo_page_modules, :subject_type
  end
end
