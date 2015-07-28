module Virgo
  class ImagesController < ApplicationController
    def index
      @images = Image.order(created_at: :desc).limit(20)

      render json: @images.map(&:redactor_json)
    end
  end
end
