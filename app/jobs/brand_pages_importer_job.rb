class BrandPagesImporterJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    self.class.set(wait: 60.minutes).perform_later(job.arguments)
  end

  def perform(brand)
    pages_data = FBPageSearcher.new(term: brand.name, token: token).call

    pages_data.each do |data|
      create_or_update_page_from(data)
    end
  end

  private

  def create_or_update_page_from(data)
    fb_page = FacebookPage.find_or_initialize_by(facebook_id: data["id"]) do |page|
      page.name = data["name"]
      page.url = data["link"]
      page.description = data["about"]
      page.image_url = data.dig("picture", "data", "url")
    end

    fb_page.save!
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
