# cleanup sidekiq queues
# Sidekiq::Queue.new("pages").clear
# Sidekiq::Queue.new("posts").clear
# Sidekiq::ScheduledSet.new.select do |j|
#   j.display_class.in?(["PagesImporterJob", "PostsImporterJob"])
# end.each(&:delete)

Role::DEFAULT_ROLE_NAMES.each do |role_name|
	Role.create(name: role_name)
end

u = User.create! email: "admin@oommaa.com",
             password: "admin@123",
             name: "Admin User",
             confirmed_at: Time.now

u.roles << Role.admin


# u.build_employee 
u = User.create! email: "hr@oommaa.com",
             password: "hr@123",
             name: "Hr User",
             confirmed_at: Time.now

u.roles << Role.hr

# ["Dallas Cowboys", "Cowboys Fan Pages"].each do |brand|
#   Brand.create!(name: brand)
# end

# ["Limited time", "Order now", "Tag 3 friends", "Yes if you would wear", "Click here to get yours", "Tag someone who would wear this"].each do |keyword|
#   Keyword.create!(name: keyword)
# end
