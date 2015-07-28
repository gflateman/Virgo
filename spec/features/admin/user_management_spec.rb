require 'rails_helper'

describe "Admin user management workflow", type: :feature, js: true do
  include CapybaraCommon

  before :all do
    @admin = create :user
    login_as(@admin, :scope => :user)
  end

  it "should let me add a new editor in admin" do
    visit virgo.admin_users_path

    first(:css, '#new-user-link').click

    fill_in_user_details
  end

  private

  def fill_in_user_details
    fill_in 'user_username', with: "user_#{Time.now.to_i}"
    fill_in 'user_first_name', with: Faker::Name.first_name
    fill_in 'user_last_name', with: Faker::Name.last_name
    fill_in 'user_byline', with: "Byline #{Time.now.to_i}"
    select 'Editor', from: 'user_role'
    fill_in 'user_email', with: "email#{Time.now.to_i}@example.com"
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    first(:css, '#save-user').click
    expect(page).to have_content('Account created successfully')
  end
end
