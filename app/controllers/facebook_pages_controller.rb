class FacebookPagesController < ApplicationController
  def index
    authorize FacebookPage
    @status = if params[:q].present? and params[:q][:status].present?
      params[:q][:status]
    elsif FacebookPage::statuses.include?(params[:status])
      params[:status]
    else
     "brand_page"
    end

    if @status == "affiliate_page"
      @q = policy_scope(FacebookPage).affiliate_page.ransack(params[:q])
    else
      @q = policy_scope(FacebookPage).brand_page.ransack(params[:q])
    end
    @q.sorts = "created_at desc" if @q.sorts.empty?

    @facebook_pages = @q.result.
                         page(params[:page])
  end

  def create
    authorize FacebookPage
    valid_url_if_present = true
    url = params[:facebook_page][:url]
    if url =~ /\A#{URI::regexp}\z/ || !url.present?
      flash[:notice] = "Requested Page is added to enqueued job."
    else
      flash[:alert] = "URL is not valid Please enter valid url or try adding complete url."
      valid_url_if_present = false
    end
    AffiliatePageImporterJob.perform_async(params[:facebook_page][:name], params[:facebook_page][:url]) if valid_url_if_present
    redirect_back(fallback_location: facebook_pages_path(status: 'affiliate_page'))
  end

  def destroy
    authorize FacebookPage
    facebook_page = FacebookPage.find(params[:id])
    posts_count = facebook_page.facebook_posts.size

    facebook_page.create_activity(:destroy, owner: current_user, parameters: { name: facebook_page.name })
    status = facebook_page.status
    facebook_page.destroy!

    flash[:notice] = "1 Page and #{posts_count} post were successfully destroyed."
    redirect_to facebook_pages_path(status: status)
  end

  def search
    authorize FacebookPage
    data = DefaultSearchFilter.new(term: params[:term], page: params[:page]).call('FacebookPage',current_user)
    render json: { results: data[:results], size: data[:size] }
  end
end
