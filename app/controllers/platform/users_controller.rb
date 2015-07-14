module Platform
  class UsersController < ApplicationController
    before_filter :set_user, only: member_actions

    def show
      @posts = @user.posts.latest.page(page_param)
    end

    def locate
      geo_result = geocode_ip(ip_param || request.remote_ip)

      if geo_result.success
        render json: {
          status: :success,
          lat: geo_result.lat,
          lng: geo_result.lng
        }
      else
        render json: {
          status: :err
        }
      end
    end

    private

    def set_user
      @user = User.friendly.find(id_param)
    end

    def geocode_ip(ip)
      ip_geocoder.geocode(ip)
    end

    def ip_geocoder
      Geokit::Geocoders::MaxmindCityGeocoder
    end

    def ip_param
      params.permit(:ip)[:ip]
    end
  end
end
