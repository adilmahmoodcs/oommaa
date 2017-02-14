class PostsController < ApplicationController
  def index
    @posts = FacebookPost.all

    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @posts = @posts.public_send(params[:status])
      @status = params[:status]
    end

    @posts = @posts.page(params[:page])
  end

  def change_status
    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @post = FacebookPost.find(params[:post_id])
      @post.status = params[:status]
      @post.save!
    end

    head :no_content
  end
end
