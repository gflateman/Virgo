module CapybaraCommon
  def js_click(sel)
    page.execute_script("$('#{sel}').click()")
  end

  def include_hidden_fields
    Capybara.ignore_hidden_elements = false
    yield
    Capybara.ignore_hidden_elements = true
  end
end
