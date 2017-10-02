# cleanup sidekiq queues
# Sidekiq::Queue.new("pages").clear
# Sidekiq::Queue.new("posts").clear
# Sidekiq::ScheduledSet.new.select do |j|
#   j.display_class.in?(["PagesImporterJob", "PostsImporterJob"])
# end.each(&:delete)

Right.seed
Role.seed

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

u = User.create! email: "manager@oommaa.com",
             password: "manager@123",
             name: "Manager User",
             confirmed_at: Time.now

u.roles << Role.manager

u = User.create! email: "employee@oommaa.com",
             password: "employee@123",
             name: "Employee User",
             confirmed_at: Time.now

# u.roles << Role.employee
