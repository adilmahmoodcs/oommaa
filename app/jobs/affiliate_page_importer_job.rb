class AffiliatePageImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "pages", retry: 5

  def perform(affiliate_page_name, affiliate_page_url = nil)
    @affiliate_page_name = affiliate_page_name
    @affiliate_page_url = affiliate_page_url
    return unless @affiliate_page_name

    begin
      import_pages
    rescue Koala::Facebook::ClientError => e
      # Application request limit reached
      logger.info "AffiliatePageImporter: rate limiting, re-enqueued" if e.fb_error_code == 4
      raise e
    end
  end

  private

  def import_pages
    pages_data = FBPageSearcher.new(term: @affiliate_page_name, token: token).call

    pages_data.each do |data|
      # create new Affiliate page only if its not present
      unless FacebookPage.exists?(facebook_id: data["id"])
        # If url is given then only creates the page with matching url
        if @affiliate_page_url.present? && (@affiliate_page_url == data["link"] || @affiliate_page_url.start_with?(data["link"]))
          page = create_page(data)
          break
        elsif  (@affiliate_page_name == data['name'] || data['name'].start_with?(@affiliate_page_name)) && !@affiliate_page_url.present?
          # else create the page that starts with or matches the exact given name
          page = create_page(data)
        else
          logger.info "AffiliatePageImporter: skipping non-matching page '#{data['name']}' with given url"
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

  def create_page(data)
    page = FacebookPage.create!(
      facebook_id: data["id"],
      name: data["name"],
      url: data["link"],
      image_url: data.dig("picture", "data", "url"),
      status: 'affiliate_page'
    )
    AffiliatePagePostImporterJob.perform_async(page.id)
    logger.info "AffiliatePageImporter: new affiliate FacebookPage #{page.id} created}"
    page
  end
end
