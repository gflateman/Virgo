if Rails.env.production?
  Rails.application.config.mailchimp = {
    api_key: "b9c968982cb5219d687fec1fc01d32e0-us11",
    list_id: "0b9fea5550"
  }
else
  Rails.application.config.mailchimp = {
    api_key: "b9c968982cb5219d687fec1fc01d32e0-us11",
    list_id: "36694a6468"
  }
end

Gibbon::API.timeout = 30
Gibbon::API.throws_exceptions = true
Gibbon::API.api_key = Rails.application.config.mailchimp[:api_key]
