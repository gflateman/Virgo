namespace :platform do
  namespace :posts do
    task publish_scheduled: :environment do
      Platform::Post.publish_scheduled!
    end
  end
end
