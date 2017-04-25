class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :devise_permitted_parameters, if: :devise_controller?
  before_action :set_variable_for_orignal_user
  # pundit checks
  after_action :verify_authorized, unless: :skip_autharization
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

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

  def set_variable_for_orignal_user
    if controller_name == 'switch_user' and action_name == "remember_user"
      if params[:remember] == 'true'
        session[:orignal_user_id] = current_user.id
        session[:orignal_user_name] = current_user.name
        session[:orignal_user_email] = current_user.email
      elsif params[:remember] == 'false'
        session.delete(:orignal_user_id)
        session.delete(:orignal_user_name)
        session.delete(:orignal_user_email)
      end
    end
    puts "0000000000000000000000000000000000000000000000000000000000000000000000000000"
    puts session[:orignal_user_id]
    puts session[:orignal_user_name]
    puts session[:orignal_user_email]
  end
end
