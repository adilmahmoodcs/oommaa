class PostsController < ApplicationController
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
