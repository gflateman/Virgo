module Platform
  class Site < ActiveRecord::Base
    has_paper_trail only: [:weekly_newsletter_intro_copy]

    after_save :expire_site_key

    def self.instance
      @instance ||= begin
        _instance = first

        _instance = create! if _instance.nil?

        _instance
      end
    end
  end
end
