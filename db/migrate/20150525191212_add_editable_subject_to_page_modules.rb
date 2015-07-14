class AddEditableSubjectToPageModules < ActiveRecord::Migration
  def up
    add_column :page_modules, :editable_subject, :boolean, default: false
  end

  def down
    remove_column :page_modules, :editable_subject
  end
end
