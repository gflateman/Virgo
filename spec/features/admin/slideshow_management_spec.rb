require 'rails_helper'

describe "Admin slideshow management workflow", type: :feature, js: true do
  include CapybaraCommon

  before :all do
    @admin = create :user
    login_as(@admin, :scope => :user)
  end

  it "should let me add a new editor in admin" do
    visit platform.admin_slideshows_path

    click_link 'new-slideshow-link'

    fill_in "slideshow_name", with: "Slideshow #{Time.now.to_i}"

    find('#slideshow-form-submit').click

    expect(page).to have_content("Slideshow successfully created")

    upload_slide(image_file_paths.first)

    upload_slide(image_file_paths.second)

    find('#slideshow-form-submit').click

    expect(page).to have_content('Slideshow settings saved')
  end

  private

  def upload_slide(fpath)
    click_link 'new-slide-link'

    click_link 'add-slide-image'

    click_link 'upload-tab-btn'

    expect(page).to have_selector('#new_image')

    # page.execute_script "$('#image-upload-file-field').css({opacity: 1, zIndex: 999})"

    include_hidden_fields do
      attach_file 'image-upload-file-field', fpath
    end

    fill_in 'image_name', with: "Image #{Time.now.to_i}"

    first(:css, '#upload-button').click

    expect(page).to have_selector('#upload-success-dismiss')

    first(:css, '#upload-success-dismiss').click

    js_click '#save-slide'

    expect(page).to have_content('Your new slide has been added')
  end

  def image_file_paths
    ["doge.jpg", "doge2.jpg"].map do |filename|
      File.expand_path("../../../data/#{filename}", __FILE__)
    end
  end
end
