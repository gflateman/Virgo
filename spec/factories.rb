FactoryGirl.define do
  factory :site, class: Virgo::Site do
    name "The Site"
  end

  factory :user, class: Virgo::User do
    sequence(:username) { |n| "Faker::Internet.user_name#{n}" }
    byline { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role :admin
  end

  factory :category, class: Virgo::Category do
    name { "#{Faker::Lorem.words(1)} #{Time.now.to_i}" }
  end

  factory :post, class: Virgo::Post do
    association :author, factory: :user
    headline { Faker::Lorem.words.join(" ") + " " + Time.now.to_i.to_s }
    body { Faker::Lorem.paragraph(2) }
    status 'published'
    publish_at { 30.seconds.ago }
    live true

    after :build do |post|
      cat = create(:category)
      post.categories << cat
    end
  end
end
