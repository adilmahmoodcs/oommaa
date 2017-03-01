class ImportsController < ApplicationController
  def url
  end

  def create_from_url
    if url = params[:url].presence
      PostImporterJob.perform_async(url, current_user.email, params[:brand_id])
      current_user.create_activity(:url_added, owner: current_user, parameters: { name: url })
      flash[:notice] = "A job to import this post was enqueued."
    else
      flash[:alert] = "Unable to parse URL. It may be missing, misspelled or not yet supported."
    end

    redirect_back(fallback_location: url_imports_path)
  end
end
