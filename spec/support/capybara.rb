Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.javascript_driver = :chrome

Capybara.default_wait_time = 30.seconds

Capybara.raise_server_errors = false
