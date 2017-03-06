class FacebookPostsController < ApplicationController
  before_action :set_facebook_post, only: [:edit, :update]

  def index
    params[:q] ||= {}
    params[:q][:status_eq] ||= "not_suspect"
    params[:q].delete(:status_eq) unless params[:q][:status_eq].in?(FacebookPost.statuses.keys)

    @q = FacebookPost.ransack(params[:q])
    @q.sorts = "published_at desc" if @q.sorts.empty?

    @posts = @q.result.
                includes(:facebook_page, :ad_screenshots, :product_screenshots).
                page(params[:page])
    @status = params[:q][:status_eq]
  end

  def edit
  end

  def update
    if @facebook_post.update(facebook_post_params)
      @facebook_post.create_activity(:update, owner: current_user, parameters: { name: @facebook_post.name })
      redirect_to @facebook_post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def export
    respond_to do |format|
      @q = FacebookPost.ransack(params[:q])
      @q.sorts = "blacklisted_at desc" if @q.sorts.empty?

      format.html do
        @posts = @q.result.
                    blacklisted_or_reported_to_facebook.
                    includes(:facebook_page, :ad_screenshots, :product_screenshots).
                    page(params[:page])

        if params[:from].present?
          @posts = @posts.where("blacklisted_at >= ?", Date.parse(params[:from]).beginning_of_day)
        end
        if params[:to].present?
          @posts = @posts.where("blacklisted_at <= ?", Date.parse(params[:to]).end_of_day)
        end
      end

      format.csv do
        posts = FacebookPost.blacklisted_or_reported_to_facebook.
                             includes(:facebook_page, :ad_screenshots, :product_screenshots).
                             order("blacklisted_at desc")
        if params[:from].present?
          posts = posts.where("blacklisted_at >= ?", Date.parse(params[:from]).beginning_of_day)
        end
        if params[:to].present?
          posts = posts.where("blacklisted_at <= ?", Date.parse(params[:to]).end_of_day)
        end

        send_data PostsCSVExporter.new(posts).call,
                  filename: "blacklist_export_#{Time.now.to_i}.csv"
      end
    end
  end

  def change_status
    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @post = FacebookPost.find(params[:post_id])
      @post.change_status_to!(params[:status], current_user.email)
      @post.create_activity(params[:status], owner: current_user, parameters: { name: @post.permalink })

      callback_method = "after_#{params[:status]}"
      send(callback_method) if respond_to?(callback_method, true)
    end

    redirect_back(fallback_location: root_path)
  end

  def mass_change_status
    if params[:new_status] && params[:new_status].in?(FacebookPost.statuses.keys)
      posts = FacebookPost.ransack(params[:q]).result
      posts.each do |post|
        post.change_status_to!(params[:new_status], current_user.email)
      end

      current_user.create_activity("mass_#{params[:new_status]}",
                                   owner: current_user,
                                   parameters: { name: "#{posts.size} posts" })
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def set_facebook_post
    @facebook_post = FacebookPost.find(params[:id])
  end

  def facebook_post_params
    params.require(:facebook_post).permit(:permalink)
  end

  def after_reported_to_facebook
    ShutDownCheckerJob.perform_async(@post.id)
  end

  def after_blacklisted
    Domain.blacklist_new_domains!(@post.all_domains)
    PostScreenshotsJob.perform_async(@post.id)
  end
end
