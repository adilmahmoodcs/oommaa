class PagesImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "pages"

  def perform(brand_id)
    import_pages(brand_id)

    self.class.perform_in(60.minutes, brand_id)
  end

  private

  def import_pages(brand_id)
    brand = Brand.find(brand_id)
    pages_data = FBPageSearcher.new(term: brand.name, token: token).call

    pages_data.each do |data|
      if !FacebookPage.exists?(facebook_id: data["id"])
        FacebookPage.create!(
          facebook_id: data["id"],
          name: data["name"],
          url: data["link"],
          image_url: data.dig("picture", "data", "url"),
          brand_ids: [brand.id]
        )
      else
        page = FacebookPage.find_by(facebook_id: data["id"])
        if !brand.id.in?(page.brand_ids)
          page.brand_ids << brand.id
          page.save!
        end
      end
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
