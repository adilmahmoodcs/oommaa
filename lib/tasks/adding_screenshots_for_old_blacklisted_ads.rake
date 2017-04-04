namespace :adding_screenshots_for_old_blacklisted_ads do
  desc "TODO"
  task add_screenshots: :environment do
    FacebookPost.includes(:screenshots).where(status: 3).select { |fp| fp.screenshots.empty? }.try(:each) do |post|
      PostScreenshotsJob.perform_async(post.id)
    end
  end

end
