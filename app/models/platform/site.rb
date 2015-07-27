module Platform
  class Site < ActiveRecord::Base
    has_paper_trail only: [:weekly_newsletter_intro_copy]

    after_save :expire_site_key

    validates :name, presence: true

    def self.instance
      _instance = first

      _instance = create! if _instance.nil?

      _instance
    end

    def generate_dummy_data!(opts={})
      if Post.all.empty? || opts[:force] == true
        require 'faker'
        I18n.reload! # see https://github.com/stympy/faker/issues/285

        post = Post.new(
          headline: "Your First Post",
          subhead: Faker::Lorem.paragraph,
          author: User.order(id: :asc).first,
          body: Faker::Lorem.paragraphs(10).map{|p| "<p>#{p}</p>"}.join,
          status: :published,
          publish_at: Time.now,
          live: true
        )

        post.save!
      end
    end
  end
end
