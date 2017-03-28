# cleanup sidekiq queues
Sidekiq::Queue.new("pages").clear
Sidekiq::Queue.new("posts").clear
Sidekiq::ScheduledSet.new.select do |j|
  j.display_class.in?(["PagesImporterJob", "PostsImporterJob"])
end.each(&:delete)

User.create! email: "admin@example.com",
             password: "password",
             name: "Admin User",
             role: "admin",
             confirmed_at: Time.now

["Dallas Cowboys", "Cowboys Fan Pages"].each do |brand|
  Brand.create!(name: brand)
end

["Limited time", "Order now", "Tag 3 friends", "Yes if you would wear", "Click here to get yours", "Tag someone who would wear this"].each do |keyword|
  Keyword.create!(name: keyword)
end
