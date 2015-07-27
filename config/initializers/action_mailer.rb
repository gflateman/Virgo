# Assumes you are running the development server on port 3000, change if otherwise
if ['test', 'development'].include?(Rails.env)
  Rails.application.config.action_mailer.default_url_options ||= {}
  Rails.application.config.action_mailer.default_url_options[:host] = "localhost:3000"
  Rails.application.config.action_mailer.asset_host = "http://localhost:3000"
end

