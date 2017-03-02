class PagesImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "pages"

  def perform(brand_id)
    brand = Brand.find_by(id: brand_id)
    return unless brand # brand was deleted

    import_pages(brand)

    self.class.perform_in(60.minutes, brand_id)
  end

  private

  def import_pages(brand)
    pages_data = FBPageSearcher.new(term: brand.name, token: token).call

    pages_data.each do |data|
      if !FacebookPage.exists?(facebook_id: data["id"])
        page = FacebookPage.create!(
          facebook_id: data["id"],
          name: data["name"],
          url: data["link"],
          image_url: data.dig("picture", "data", "url"),
          brand_ids: [brand.id]
        )
        PostsImporterJob.perform_async(page.id)
        logger.info "PagesImporterJob: new FacebookPage #{page.id} created for Brand #{brand.id}"
      else
        page = FacebookPage.find_by(facebook_id: data["id"])
        if !brand.id.in?(page.brand_ids)
          page.brand_ids << brand.id
          page.save!
          logger.info "PagesImporterJob: new Brand #{brand.id} added to FacebookPage #{page.id}"
        end
      end
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
