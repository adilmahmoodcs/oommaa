namespace :remove_old_ignored_ads do
  desc "TODO"
  task remove_60_days_old_ignored_ads: :environment do
    FacebookPost.ignored.find_each do |post|
      post.destroy if post.created_at.to_date <= Date.today
    end
  end

end
