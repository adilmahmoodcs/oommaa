class MassChangeStatusForPostsJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(new_status, current_user_id)
    begin
      posts = FacebookPost.unscoped.where(mass_job_status: "to_be_#{new_status}")
      current_user = User.find(current_user_id)
    rescue
      raise "Records or User Not Found."
    end

    #Update status for posts except if the status is ignored, ignored ads are to be removed now.
    if new_status != 'ignored'
      posts.each do |post|
        post.change_status_to!(new_status, current_user.email)
      end
      posts.update_all(mass_job_status: :no_status)
    elsif new_status == 'ignored'
      posts.each do |post|
        post.destroy!
      end
    end

    current_user.create_activity("mass_#{new_status}",
                                   owner: current_user,
                                   parameters: { name: "#{posts.size} posts" })
  end
end
