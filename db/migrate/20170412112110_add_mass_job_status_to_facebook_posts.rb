class AddMassJobStatusToFacebookPosts < ActiveRecord::Migration[5.0]
  def up
    add_column :facebook_posts, :mass_job_status, :integer, default: 0
  end
  def down
    remove_column :facebook_posts, :mass_job_status, :integer
  end
end
