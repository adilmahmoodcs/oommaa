class ImportsController < ApplicationController
  def url
    authorize :import, :url?
    @brands = current_user.licensor.try(:brands) if current_user.confirmed_client?
  end

  def create_from_url
    authorize :import, :create_from_url?
    if params[:url].blank? || params[:brand_ids].blank? || params[:brand_ids].none?
      flash[:alert] = "Error: please fill all the fields"
      redirect_to url_imports_path and return
    end

    PostImporterJob.perform_async(params[:url], current_user.email, params[:brand_ids])
    current_user.create_activity(:url_added, owner: current_user, parameters: { name: params[:url] })

    flash[:notice] = "A job to import this post was enqueued."
    redirect_to url_imports_path
  end
end
