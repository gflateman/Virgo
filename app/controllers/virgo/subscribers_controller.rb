module Virgo
  class SubscribersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      @subscriber = Subscriber.new(subscriber_params)

      if @subscriber.save
        render json: {
          status: :success,
          subscriber: @subscriber,
          html: render_content(partial: '/virgo/subscribers/success_modal')
        }
      else
        render json: {
          status: :err,
          subscriber: @subscriber,
          message: @subscriber.errors.full_messages,
          html: render_content(partial: '/virgo/common/list_signup')
        }
      end
    end

    def modal
      if request.post?
        @subscriber = Subscriber.new(subscriber_params)

        if @subscriber.save
          render json: {
            status: :success,
            html: render_content(partial: '/virgo/subscribers/success_modal')
          }
        else
          render json: {
            status: :err,
            html: render_content('/virgo/subscribers/modal', layout: false)
          }
        end
      else
        @subscriber = Subscriber.new

        render json: {
          html: render_content('/virgo/subscribers/modal', layout: false)
        }
      end
    end

    private

    def subscriber_params
      params.permit(subscriber: [:email])[:subscriber]
    end
  end
end
