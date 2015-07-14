class Subscriber < ActiveRecord::Base
  validates :email, presence: true, uniqueness: {message: "is already subscribed to the mailing list"}, email: true, reduce: true

  after_create :send_to_mailchimp!

  private

  def send_to_mailchimp!
    gb = Gibbon::API.new(mailchimp_config[:api_key], {timeout: 40})

    result = gb.lists.subscribe({
      id: mailchimp_config[:list_id],
      email: {email: email},
      merge_vars: {},
      double_optin: false
    })

    true
  end

  def mailchimp_config
    Rails.application.config.mailchimp
  end
end
