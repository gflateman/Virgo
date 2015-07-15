module Platform
  class PublishJob < Que::Job
    def perform
      Post.publish_scheduled!
      Platform::PublishJobManager.notify_complete!
    end
  end
end
