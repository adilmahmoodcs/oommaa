class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_permitted_parameters, if: :devise_controller?
  # pundit checks
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  private

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :licensor_id])
  end
end
