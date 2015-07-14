if Rails.env.production?
  Rails.application.config.action_mailer.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :address              => Rails.application.secrets.smtp_host,
    :port                 => 587,
    :user_name            => Rails.application.secrets.smtp_user,
    :password             => Rails.application.secrets.smtp_password,
    :authentication       => :login,
    :enable_starttls_auto => true,
    :openssl_verify_mode => 'none'
  }
else
  Rails.application.config.action_mailer.delivery_method = :sendmail
end

ActionMailer::Base.register_interceptor(Platform::DevelopmentMailInterceptor) if ['development'].include?(Rails.env)

Rails.application.config.action_mailer.default_url_options = {host: Rails.application.config.domain, only_path: false}

Rails.application.config.after_initialize do
  Rails.application.routes.default_url_options[:host] = Rails.application.config.domain
end

if ['test', 'development'].include?(Rails.env)
  Rails.application.config.action_mailer.default_url_options[:host] = "localhost:3000"
  Rails.application.config.action_mailer.asset_host = "http://localhost:3000"
end

