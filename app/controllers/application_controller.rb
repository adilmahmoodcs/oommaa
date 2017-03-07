class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_permitted_parameters, if: :devise_controller?

  private

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :licensor_id])
  end
end
