namespace :check_for_facebook_shutdown_for_blacklisted_posts do
  desc "TODO"
  task blacklisted_shutdown_checker: :environment do
    FacebookPost.blacklisted.find_each do |post|
      ShutDownCheckerJob.perform_async(post.id)
    end
  end

end
