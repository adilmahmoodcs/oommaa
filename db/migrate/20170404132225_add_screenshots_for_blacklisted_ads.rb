require 'rake' 
class AddScreenshotsForBlacklistedAds < ActiveRecord::Migration[5.0]
  def change
    say_with_time "Adding Screen-shots for blacklisted ads"  do
      Rake::Task['adding_screenshots_for_old_blacklisted_ads:add_screenshots'].invoke
    end
  end
end
