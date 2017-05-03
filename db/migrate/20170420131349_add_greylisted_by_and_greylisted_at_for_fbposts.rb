class AddGreylistedByAndGreylistedAtForFbposts < ActiveRecord::Migration[5.0]
  def up
    add_column :facebook_posts, :greylisted_at, :datetime, after: :blacklisted_by
    add_column :facebook_posts, :greylisted_by, :string, after: :greylisted_at
    populate_greylisted_fields
  end

  def down
    remove_column :facebook_posts, :greylisted_at, :datetime
    remove_column :facebook_posts, :greylisted_by, :string
  end

  private
    def populate_greylisted_fields
      FacebookPost.greylisted.where(added_by: nil).update_all(greylisted_by: "PostsImporterJob", greylisted_at: Time.now)
      FacebookPost.greylisted.where.not(added_by: nil).find_each do |post|
        post.update(greylisted_by: post.added_by, greylisted_at: Time.now)
      end
    end
end
