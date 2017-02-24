# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  status     :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ApplicationRecord
  include PublicActivity::Common

  enum status: [:blacklisted, :whitelisted]

  validates :name, presence: true
  validates :name, uniqueness: true

  ransacker :name_case_insensitive, type: :string do
    arel_table[:name].lower
  end

  # create some new blacklisted domains
  # existing domains are not touched
  def self.blacklist_new_domains!(names)
    names.each do |name|
      create!(name: name, status: :blacklisted) unless exists?(name: name)
    end
  end

  def posts
    FacebookPost.where("? = ANY (all_domains)", name)
  end

  # if whitelisted, re-check all backlisted posts (and vice versa)
  def update_posts!
    post_scope = if whitelisted?
      :blacklisted
    elsif blacklisted?
      :whitelisted
    end
    return unless post_scope

    posts.select(:id).public_send(post_scope).each do |post|
      PostStatusJob.perform_async(post.id)
    end
  end
end
