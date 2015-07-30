module Virgo
  module ApplicationHelper
    def controller?(*controller)
      controller.include?(params[:controller])
    end

    def action?(*action)
      action.include?(params[:action])
    end

    def alerts(options={})
      render_to_string(:partial => "/virgo/common/alerts", locals: options).html_safe
    end

    def superuser?
      current_user && current_user.superuser?
    end

    def admin?
      current_user && current_user.admin?
    end

    def admin_access?
      current_user && current_user.admin_access?
    end

    def admin_view?
      params[:controller].starts_with?('virgo/admin')
    end

    def admin_access?
      current_user && current_user.admin_access?
    end

    def production?
      Rails.env.production?
    end

    def word_count(text)
      text ||= ""
      text.scan(/\w+/).length
    end

    def base_errors(record)
      render_to_string(:partial => "/virgo/common/base_errors", locals: {record: record}).html_safe
    end

    def post_time_format
      "%B %e, %Y at %l:%M%P"
    end

    # replaces spaces between tags plus newline characters in an html string
    def compact_html(text)
      _text = text.gsub(/\>(?<spaces>\s+)[\n|\<]/) { |m|
        m.gsub($1, "")
      }
      _text.gsub("\n", "").html_safe
    end

    def expanded_post_url(post, extra_opts={})
      post_detail_url(post)
    end

    def site_key
       "#{Time.now.beginning_of_day.to_i}-#{Rails.cache.read('site_key')}"
    end

    def redis_timestamp_key_for(klass, record_id)
      ActiveRecord::Base.redis_timestamp_key_for(klass, record_id)
    end

    def post_timestamp(post_id)
      Rails.cache.fetch(redis_timestamp_key_for(Virgo::Post, post_id)) do
        "#{redis_timestamp_key_for(Post, post_id)}-#{Time.now.to_i}"
      end
    end

    def category_timestamp(category_id)
      Rails.cache.fetch(redis_timestamp_key_for(Virgo::Category, category_id)) do
        "#{redis_timestamp_key_for(Category, category_id)}-#{Time.now.to_i}"
      end
    end

    def column_timestamp(column_id)
      Rails.cache.fetch(redis_timestamp_key_for(Virgo::Column, column_id)) do
        "#{redis_timestamp_key_for(Column, column_id)}-#{Time.now.to_i}"
      end
    end

    def tabbed_param
      params.permit(:tabbed)[:tabbed].try(:to_bool)
    end

    def site
      @site ||= Site.instance
    end

    def decode_html_entities(text)
      @html_entities ||= HTMLEntities.new
      text = text.html_safe.gsub("'", "'") if text.present?
      @html_entities.decode(text)
    end

    def is_admin_view?
      @_is_admin_view || false
    end

    def page_url
      _url = "#{request.protocol}#{Rails.application.config.domain}"

      _url += ":#{request.port}" if request.port.present? && request.port != 80 && request.port != 443

      _url += request.original_fullpath
    end
  end
end
