namespace :update_status_for_whitelisted_domains do
  desc "TODO"
  task update_posts_status: :environment do
    Domain.whitelisted.where(name: ["dallascowboys.com","dallasnews.com"]).each do |domain|
      domain.posts.find_each do |post|
        PostStatusJob.perform_async(post.id)
      end
    end
  end

end
