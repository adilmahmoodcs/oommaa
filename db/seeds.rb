# cleanup sidekiq queues
Sidekiq::Queue.new("pages").clear
Sidekiq::Queue.new("posts").clear
Sidekiq::ScheduledSet.new.select do |j|
  j.display_class.in?(["PagesImporterJob", "PostsImporterJob"])
end.each(&:delete)

User.create!(email: "admin@example.com", password: "password")

["Dallas Cowboys", "Cowboys Fan Pages"].each do |brand|
  Brand.create!(name: brand)
end

["Limited time", "Order now", "Tag 3 friends", "Yes if you would wear", "Click here to get yours", "Tag someone who would wear this", "Order your shirt here", "Buy 2 or more to save on shipping!", "Limited Edition", "Get it here", "Hottest Selling", "Real Fan", "Quality", "Order it here", "#gameday", "LTD.", "Limited Quantities", "Limited Time Out", "T-shirt for (team) fans", "Tag a friend", "Share with friends", "Order Here", "Get this amazing shirt", "Get your here", "Buy it or lost it forever", "Tag/Share with friends", "You can buy it here", "Just Released", "grab one here", "time is running out"].each do |keyword|
  Keyword.create!(name: keyword)
end
