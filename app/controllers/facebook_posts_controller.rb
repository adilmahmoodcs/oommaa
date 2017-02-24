class FacebookPostsController < ApplicationController
  def index
    @q = FacebookPost.ransack(params[:q])
    @q.sorts = "published_at desc" if @q.sorts.empty?
    @posts = @q.result.includes(:facebook_page)

    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @posts = @posts.public_send(params[:status])
      @status = params[:status]
    end

    @posts = @posts.page(params[:page])
  end

  def new
    @post = FacebookPost.new
  end

  def create
    if url = facebook_post_params[:permalink].presence
      PostImporterJob.perform_async(url)
      current_user.create_activity(:url_added, owner: current_user, parameters: { name: url })
      flash[:notice] = "A job to import this post was enqueued."
    else
      flash[:alert] = "Unable to parse URL. It may be misspelled or not yet supported."
    end

    redirect_back(fallback_location: root_path)
  end

  def export
    @q = FacebookPost.ransack(params[:q])
    @q.sorts = "blacklisted_at desc" if @q.sorts.empty?
    @posts = @q.result.
                blacklisted.
                includes(:facebook_page).
                page(params[:page])

    if params[:from].present?
      @posts = @posts.where("blacklisted_at >= ?", Date.parse(params[:from]).beginning_of_day)
    end
    if params[:to].present?
      @posts = @posts.where("blacklisted_at <= ?", Date.parse(params[:to]).end_of_day)
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data PostsCSVExporter.new(@posts).call,
                  filename: "blacklist_export_#{Time.now.to_i}.csv"
      end
    end
  end

  def change_status
    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @post = FacebookPost.find(params[:post_id])
      @post.change_status_to!(params[:status], current_user.email)
      @post.blacklist_domains! if @post.blacklisted?
      @post.create_activity(params[:status], owner: current_user, parameters: { name: @post.permalink })

      callback_method = "after_#{params[:status]}"
      send(callback_method) if respond_to?(callback_method, true)
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def facebook_post_params
    params.require(:facebook_post).permit(:permalink)
  end

  def after_reported_to_facebook
    ShutDownCheckerJob.perform_async(@post.id)
  end
end
