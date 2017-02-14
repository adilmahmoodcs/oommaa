class PagesImporterJob < ApplicationJob
  queue_as :pages

  after_perform do |job|
    self.class.set(wait: 60.minutes).perform_later(job.arguments)
  end

  def perform(brand)
    pages_data = FBPageSearcher.new(term: brand.name, token: token).call

    pages_data.each do |data|
      unless FacebookPage.exists?(facebook_id: data["id"])
        FacebookPage.create!(
          facebook_id: data["id"],
          name: data["name"],
          url: data["link"],
          image_url: data.dig("picture", "data", "url")
        )
      end
    end
  end

  private

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
