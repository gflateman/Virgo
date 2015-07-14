class RemoveListSignupModule < ActiveRecord::Migration
  def up
    mod = PageModule.find_by(name: "List Signup" )
    mod.destroy if mod
  end
end
