require 'rails_helper'

describe "Admin post management workflow", type: :feature, js: true do
  include CapybaraCommon

  before :all do
    @admin = create :user
    login_as(@admin, :scope => :user)
  end

  it "should let me create a post in admin" do
    visit_admin_posts_index
    click_new_post_link
    fill_in_post_content
  end

  private

  def visit_admin_posts_index
    visit platform.admin_posts_path
  end

  def click_new_post_link
    first(:css, '#new-post-link').click
  end

  def fill_in_post_content
    fill_in 'headline-input', with: "A Post Headline"
    fill_in 'subhead-input', with: "A Post Headline"
    tinymce_fill_in "post[body]", with: Faker::Lorem.paragraphs(5).join
    fill_in 'excerpt-input', with: "A Post excerpt"
    first(:css, '#new-category-link').click

    expect(page).to have_selector('#category-modal', visible: true)

    fill_in 'category_name', with: "Category #{Time.now.to_i}"
    first(:css, '#category-submit').click

    expect(page).to have_selector('#category-success-message', visible: true)

    first(:css, '#category-modal-close').click

    expect(page).not_to have_css('#category-modal')

    # terrible I know but the above "element not present" check is not actually waiting
    # til the modal is totally
    js_click '#primary-save-button'

    expect(page).to have_content("Post successfully created")
  end

  def tinymce_fill_in(name, options = {})
    if page.driver.browser.browser == :chrome
      page.driver.browser.switch_to.frame("#{name}_ifr")
      page.find(:css, '#tinymce').native.send_keys(options[:with])
      page.driver.browser.switch_to.default_content
    else
      page.execute_script("tinyMCE.get('#{name}').setContent('#{options[:with]}')")
    end
  end
end
