namespace :adding_screenshots_for_old_blacklisted_ads do
  desc "TODO"
  task add_screenshots: :environment do
    FacebookPost.where(status: [3, 4]).find_each do |post|
      PostScreenshotsJob.perform_async(post.id) if post.screenshots.none?
    end
  end

end
