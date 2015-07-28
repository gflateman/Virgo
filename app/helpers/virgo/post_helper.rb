module Virgo
  module PostHelper
    def post_status_label(post)
      if post.draft?
        "<span class='label label-danger'>Draft</span>".html_safe
      elsif post.assigned?
        "<span class='label label-info'>Assigned</span>".html_safe
      elsif post.published?
        "<span class='label label-primary'>Published</span>".html_safe
      elsif post.killed?
        "<span class='label label-danger'>Hidden</span>".html_safe
      elsif post.hidden?
        "<span class='label label-warning'>Hidden</span>".html_safe
      end
    end

    def post_categories(post)
      post.categories.map(&:name).join(", ")
    end

    def post_tags(post)
      post.tags.map(&:name).join(", ")
    end

    def truncate_post_to_read_more(post, opts={})
      include_link = true if opts[:link].nil?

      text = post.rendered_body

      idx = text.index("[read-more]")

      if opts[:length]
        if idx.nil? || (opts[:length] < idx)
          return truncate(strip_tags(text), length: opts[:length])
        end
      end

      if idx
        result = text[0..(idx-1)] + "<span class='ellipse'>...</span>"

        if include_link
          result += "<div class='read-more-link-wrap'>"
          result += link_to("Read More", post_detail_path(post), class: 'read-more-link')
          result += "</div>"
        end
      else
        result = text
      end

      result.html_safe
    end

    def post_category_label(post)
      if post.categories.any?
        category = post.categories.order(navbar_weight: :asc).first

        html = "
          <div class='category-label'>
            <span class='category-name'>#{category.name}</span>
          </div>
        "

        html.html_safe
      else
        ""
      end
    end

    def post_byline(post, opts={})
      html = "
        <div class='post-byline'>
          <span class='post-by'>By</span> "

      unless opts[:no_links]
        html += link_to(post.author.pretty_name, user_path(post.author), class: 'post-author-link')
      else
        html += "<span class='post-author-name'>#{post.author.pretty_name}</span>"
      end

      html += "<span class='bullet'>&bull;</span>
        <span class='post-date'>#{local_time (post.publish_at || post.created_at), post_time_format}</span>
      </div>"

     html.html_safe
    end

    def featured_post_text(post, opts={})
      if post.excerpt.present? && post.show_excerpt?
        html = "
          <div class='featured-post-excerpt'>
            #{truncate post.excerpt, length: 414}
        "

        if opts[:read_more] != false
          html += "#{link_to "Read More", post_detail_path(post), class: 'read-more-link'}"
        end

        html += "</div>"

        html.html_safe
      else
        "".html_safe
      end
    end

    def post_tag(post)
      if post.tags.any?
        tag = post.post_tags.by_position.first.tag
        "
          <div class='post-tag'>
            <span class='post-tag-text'>#{tag.name}</span>
          </div>
        ".html_safe
      else
        ""
      end
    end

    def post_excerpt(post)
      if post.excerpt.present? && post.show_excerpt?
        "
          <div class='post-body post-excerpt'>
            #{post.excerpt}
            <div class='read-more-link-wrap'>
            #{link_to "Read More", post_detail_path(post), class: 'read-more-link'}
            </div>
          </div>
        ".html_safe
      else
        "
          <div class='post-body'>
            #{truncate_post_to_read_more(post)}
          </div>
        ".html_safe
      end
    end

    def post_banner_image_url(post)
      if post.show_feature_image_on_post_page
        post.featured_image.try(:image).try(:url, :wide)
      end
    end

    def rss_post(xml, post)
      xml.item {
        xml.guid(post.uuid)
        xml.pubDate(post.publish_at.to_s(:rfc822))
        xml.title(post.headline)
        xml.author(post.author.byline)
        xml.link(post.permalink)
        xml.description(post.rendered_body)

        if post.featured_image
          xml.tag!("media:content", {"url" => post.thumb_image.image.url(:email), "medium" => "image"})
        end
      }
    end
  end
end
