class FacebookPostsController < ApplicationController
  def index
    @q = FacebookPost.ransack(params[:q])
    @q.sorts = "posted_at desc" if @q.sorts.empty?
    @posts = @q.result.includes(:facebook_page)

    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @posts = @posts.public_send(params[:status])
      @status = params[:status]
    end

    @posts = @posts.page(params[:page])
  end

  def export
    @q = FacebookPost.ransack(params[:q])
    @q.sorts = "status_changed_at desc" if @q.sorts.empty?
    @posts = @q.result.
                blacklisted.
                includes(:facebook_page).
                page(params[:page])

    if params[:from].present?
      @posts = @posts.where("status_changed_at >= ?", Date.parse(params[:from]).beginning_of_day)
    end
    if params[:to].present?
      @posts = @posts.where("status_changed_at <= ?", Date.parse(params[:to]).end_of_day)
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
      @post.change_status_to!(params[:status])
      @post.create_activity(params[:status], owner: current_user, parameters: { name: @post.permalink })
    end

    redirect_to :back
  end
end
