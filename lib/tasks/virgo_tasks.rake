namespace :virgo do
  namespace :posts do
    task publish_scheduled: :environment do
      Virgo::Post.publish_scheduled!
    end
  end
end
