module Platform
  class PublishJob < Que::Job
    def run
      Que.logger.info "PublishJob performing..."
      Post.publish_scheduled!
      Platform::PublishJobManager.notify_complete!
    end
  end
end
