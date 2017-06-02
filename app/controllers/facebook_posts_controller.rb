class FacebookPostsController < ApplicationController
  before_action :set_facebook_post, only: [:edit, :update]
  after_action :verify_policy_scoped, only: [:index, :export, :mass_change_status]
  before_action :set_filter_data, only: [:index, :export]

  def index
    params[:q] ||= {}
    params[:q][:status_eq] ||= "suspect"
    params[:q].delete(:status_eq) unless params[:q][:status_eq].in?(FacebookPost.statuses.keys)

    if params[:q][:blacklisted_at_gteq].present?
      params[:q][:blacklisted_at_gteq] = Date.parse(params[:q][:blacklisted_at_gteq]).
                                              beginning_of_day
    end

    if params[:q][:blacklisted_at_lteq].present?
      params[:q][:blacklisted_at_lteq] = Date.parse(params[:q][:blacklisted_at_lteq]).
                                              end_of_day
    end

    authorize FacebookPost, "index_#{params[:q][:status_eq]}?"

    @q = policy_scope(FacebookPost).ransack(params[:q])
    @q.sorts = "published_at desc" if @q.sorts.empty?

    @posts = @q.result.
                includes({ facebook_page: { brands: :licensor } },
                         :ad_screenshots,
                         :product_screenshots)
    @status = params[:q][:status_eq]

    respond_to do |format|
      format.html do
        @posts = @posts.page(params[:page])
      end

      format.csv do
        send_data PostsCSVExporter.new(@posts.uniq).call,
                  filename: "#{@status}_export_#{Time.now.to_i}.csv"
      end
    end
  end

  def edit
    authorize @facebook_post
  end

  def update
    authorize @facebook_post
    if update_brands_for_post and (params[:facebook_post] and @facebook_post.update(facebook_post_params))
      @facebook_post.create_activity(:update, owner: current_user, parameters: { name: @facebook_post.permalink })
      flash[:notice] = 'Ad was successfully updated.'
      redirect_back(fallback_location: root_path)
    else
      render :edit
    end
  end

  def export
    authorize FacebookPost
    respond_to do |format|
      @q = policy_scope(FacebookPost).ransack(params[:q])
      @q.sorts = "blacklisted_at desc" if @q.sorts.empty?
      @posts = @q.result.
                  blacklisted_or_reported_to_facebook.
                  includes({ facebook_page: { brands: :licensor } }, :ad_screenshots, :product_screenshots)
      if params[:from].present?
        @posts = @posts.where("blacklisted_at >= ?", Date.parse(params[:from]).beginning_of_day)
      end
      if params[:to].present?
        @posts = @posts.where("blacklisted_at <= ?", Date.parse(params[:to]).end_of_day)
      end

      format.html do
        @posts = @posts.page(params[:page])
      end

      format.csv do
        send_data PostsCSVExporter.new(@posts.uniq).call,
                  filename: "blacklist_export_#{Time.now.to_i}.csv"
      end
    end
  end

  def change_status
    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @post = FacebookPost.find(params[:post_id])
      authorize @post, "change_status_#{params[:status]}?"

      @post.change_status_to!(params[:status], current_user.email)
      @post.create_activity(params[:status], owner: current_user, parameters: { name: @post.permalink })

      callback_method = "after_#{params[:status]}"
      send(callback_method) if respond_to?(callback_method, true)
    end

    redirect_back(fallback_location: root_path)
  end

  def mass_change_status
    if params[:new_status] && params[:new_status].in?(FacebookPost.statuses.keys)
      authorize FacebookPost, "mass_change_status_#{params[:new_status]}?"

      posts = policy_scope(FacebookPost).ransack(params[:q][:status_eq]).result.where("id IN (?)", params[:post_ids][0].split(","))
      success = false
      posts.each do |post|
        success = true if post.change_status_to!(params[:new_status], current_user)
      end
      # MassChangeStatusForPostsJob.perform_async(params[:new_status], current_user.id) TO-DO Remove this
      if success == true
        flash[:notice] = "#{posts.count} posts have successfully updated to #{params[:new_status]}."
      elsif !posts.present?
        flash[:alert] = "Please select posts before updating status."
      else
        flash[:alert] = "Error occurred during saving."
      end
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_facebook_post
    @facebook_post = FacebookPost.find(params[:id])
  end

  def facebook_post_params
    params.require(:facebook_post).permit(
      :facebook_report_number, :likes, all_domains: []
    )
  end

  def after_blacklisted
    Domain.blacklist_new_domains!(@post.all_domains)
    PostScreenshotsJob.perform_async(@post.id)
  end

  def set_filter_data
    if params[:q].present?
      @fb_page = DefaultSearchFilter.new(term: { id: params[:q][:facebook_page_id_eq]})
                                    .call('FacebookPage', current_user)[:results] if params[:q][:facebook_page_id_eq].present?

      @brand = DefaultSearchFilter.new(term: { id: params[:q][:facebook_page_post_brands_facebook_page_brand_brand_id_eq]})
                                  .call('Brand', current_user)[:results] if params[:q][:facebook_page_post_brands_facebook_page_brand_brand_id_eq].present?

      @licensor = DefaultSearchFilter.new(term: { id: params[:q][:facebook_page_post_brands_facebook_page_brand_brand_licensor_id_eq]})
                                     .call('Licensor', current_user)[:results] if params[:q][:facebook_page_post_brands_facebook_page_brand_brand_licensor_id_eq].present?
    end
  end

  def update_brands_for_post updated = false
    if params[:brand_ids].present?
      brands = policy_scope(Brand).find(params[:brand_ids])
      @facebook_post.facebook_page_post_brands.destroy_all
      brands.each do |brand|
        page_brand = @facebook_post.facebook_page.facebook_page_brands.find_or_initialize_by(brand_id: brand.id)
        page_brand.facebook_page_post_brands.new(facebook_post: @facebook_post)
        updated = true  if page_brand.save
      end
    end
    return updated
  end
end
