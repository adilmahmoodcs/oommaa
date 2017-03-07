class FacebookPagesController < ApplicationController
  def index
    authorize FacebookPage
    @q = policy_scope(FacebookPage).ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?

    @facebook_pages = @q.result.
                         page(params[:page])
  end

  def destroy
    authorize FacebookPage
    facebook_page = FacebookPage.find(params[:id])
    posts_count = facebook_page.facebook_posts.size

    facebook_page.create_activity(:destroy, owner: current_user, parameters: { name: facebook_page.name })
    facebook_page.destroy!

    flash[:notice] = "1 Page and #{posts_count} post were successfully destroyed."
    redirect_to facebook_pages_path
  end
end
