class PostsController < ApplicationController
  def index
    @posts = FacebookPost.all

    if params[:status] && params[:status].in?(FacebookPost.statuses.keys)
      @posts = @posts.public_send(params[:status])
      @status = params[:status]
    end

    @posts = @posts.page(params[:page])
  end
end
