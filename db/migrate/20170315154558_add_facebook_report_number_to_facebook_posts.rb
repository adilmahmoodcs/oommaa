class AddFacebookReportNumberToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :facebook_report_number, :string
  end
end
