class AffiliatePageImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "pages", retry: 5

  def perform(affiliate_page_name, affiliate_page_url = nil, affiliate_page_logo = nil, affiliate_name = nil)
    @affiliate_page_name = affiliate_page_name
    @affiliate_page_url = affiliate_page_url
    @affiliate_page_logo = affiliate_page_logo
    @name_from_url = get_facebook_page_name_from_url @affiliate_page_url if @affiliate_page_url.present?
    @page_created = false
    @affiliate_name = affiliate_name

    return unless @affiliate_page_name

    begin
      import_pages
    rescue Koala::Facebook::ClientError => e
      # Application request limit reached
      logger.info "AffiliatePageImporter: rate limiting, re-enqueued" if e.fb_error_code == 4
      logger.info "AffiliatePageImporter: Name string or the url is not valid" if e.fb_error_code == 100
      raise e
    end
  end

  private

  def import_pages
    if @affiliate_page_logo.present?
      object_id, type = FbURLParser.new(@affiliate_page_logo).call
      data = FBPhotoReader.new(object_id: object_id, token: token).call if type == :photo
      page_data = FBPageReader.new(object_id: data["from"]["id"], token: token).call if data.present?
      create_page page_data if page_data.present? and !FacebookPage.exists?(facebook_id: page_data["id"])
    end

    unless @page_created
      pages_data = FBPageSearcher.new(term: @name_from_url, token: token, limit: 5000).call if @name_from_url.present?
      pages_data = FBPageSearcher.new(term: @affiliate_page_name, token: token, limit: 5000).call if (pages_data.blank? || pages_data == [])

      find_page_to_create pages_data
    end

    if !@name_from_url.present? and @page_created == false
      pages_data = FBPageSearcher.new(term: @affiliate_page_name, token: token, limit: 5000).call
      find_page_to_create pages_data
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end

  def find_page_to_create pages_data
    pages_data.each do |data|
      # create new Affiliate page only if its not present
      unless FacebookPage.exists?(facebook_id: data["id"])
        # If url is given then only creates the page with matching url
        if @name_from_url.present? &&
          (@affiliate_page_url == data["link"] || @affiliate_page_url.start_with?(data["link"]) || data["link"].start_with?(@affiliate_page_url))
          page = create_page(data)
          break
        elsif  (@affiliate_page_name.downcase == data['name'].downcase || data['name'].downcase.start_with?(@affiliate_page_name.downcase)) && !@affiliate_page_url.present?
          # else create the page that starts with or matches the exact given name
          page = create_page(data)
        else
          logger.info "AffiliatePageImporter: skipping non-matching page '#{data['link']}' with given url"
        end
      end
    end
  end

  def create_page data
    page = FacebookPage.create!(
      facebook_id: data["id"],
      affiliate_name: @affiliate_name,
      name: data["name"],
      url: data["link"],
      image_url: data.dig("picture", "data", "url"),
      status: 'affiliate_page'
    )
    @page_created = true
    AffiliatePagePostImporterJob.perform_async(page.id)
    logger.info "AffiliatePageImporter: new affiliate FacebookPage #{page.id} created}"
    page
  end

  def get_facebook_page_name_from_url url
    page_name = url.split('facebook.com/')
    page_name = page_name.last.split('?').first.gsub(/[^a-z]/i, '')
  end
end
