namespace :updating_screenshots_for_blacklisted_and_report_to_facebook_posts do
  desc "TODO"
  task update_screenshots: :environment do
    FacebookPost.where(status: [3, 4]).find_each do |post|
      PostScreenshotsJob.perform_async(post.id) if post.screenshots.destroy_all
    end
  end
end
