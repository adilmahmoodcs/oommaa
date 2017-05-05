class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :devise_permitted_parameters, if: :devise_controller?
  before_action :set_orignal_user, if: :devise_controller?
  # pundit checks
  after_action :verify_authorized, unless: :skip_autharization
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?
  after_action :validate_switched_user

  private

  def devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :licensor_id])
  end

  def skip_autharization
    controller_name == 'switch_user' or :devise_controller?
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def set_orignal_user
    if controller_name == "sessions" and action_name == "create" and current_user.admin?
      session[:orignal_user_id] = current_user.id
    elsif action_name == "destroy"
      session.delete(:orignal_user_id)
    end
  end

  def validate_switched_user
    if controller_name == 'switch_user' and action_name == "set_current_user" and
                                            current_user.admin? and
                                            current_user.id != session[:orignal_user_id]
      session.delete(:orignal_user_id)
      sign_out(current_user)
    end
  end
end
