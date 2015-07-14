require "#{Rails.root}/vendor/geokit/geocoders/maxmind_city"

Geokit::Geocoders::MaxmindCityGeocoder.geoip_data_path = "#{Rails.root}/vendor/data/GeoLiteCity.dat"

Geokit::Geocoders::GoogleGeocoder.api_key = ENV['GOOGLE_API_KEY'] || \
                                           'AIzaSyAoXP-6cA-mKHQNV0mQiG5L7oXgD8YSs5g' # dev credential set
