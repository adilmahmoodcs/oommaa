class FacebookPagesController < ApplicationController
  def index
    @q = FacebookPage.ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?

    @facebook_pages = @q.result.
                         page(params[:page])
  end

  def destroy
    @facebook_page.create_activity(:destroy, owner: current_user, parameters: { name: @facebook_page.name })
    @facebook_page.destroy
    redirect_to facebook_pages_path, notice: 'Keyword was successfully destroyed.'
  end
end
