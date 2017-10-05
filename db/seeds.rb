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
u.create_employee!(name: 'Admin')

# u.build_employee
u = User.create! email: "hr@oommaa.com",
             password: "hr@123",
             name: "Hr User",
             confirmed_at: Time.now

u.roles << Role.hr
u.create_employee!(name: 'HR')
um = User.create! email: "manager@oommaa.com",
             password: "manager@123",
             name: "Manager User",
             confirmed_at: Time.now

um.roles << Role.manager
um.create_employee!(name: 'Manager')

u = User.create! email: "employee@oommaa.com",
             password: "employee@123",
             name: "Employee User",
             confirmed_at: Time.now

u.roles << Role.employee
u.create_employee!(name: 'Employee 1', manager_id: um.id)
