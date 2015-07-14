class AddHiddenFromAdminsToPageModules < ActiveRecord::Migration
  def change
    # hotfix - this migration is exploding in staging...
    begin
      add_column :page_modules, :hidden_from_admins, :boolean, default: false

      PageModule.where(name: ['feature heading 2 column', 'Column Focus', 'popular posts']).each do |m|
        m.update!(hidden_from_admins: true)
      end
    rescue NoMethodError
      puts "swallowed NoMethodError in migration AddColumnPageModule"
    end
  end
end
