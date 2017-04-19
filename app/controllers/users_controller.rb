class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize User
    @q = policy_scope(User).ransack(params[:q])
    @q.sorts = "id DESC" if @q.sorts.empty?
    @users = @q.result.
                includes(:licensor).
                page(params[:page])
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if request.format == 'html'
      if @user.update(user_params)
        redirect_to users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    elsif request.format == 'js' && params[:assigned_domain_id].present?
      assigned_domains = @user.assigned_domains.build(domain_id: params[:assigned_domain_id])
      if assigned_domains.save
        @response = true
      else
        @response = assigned_domains.errors.full_messages.to_sentence
      end
    end
    respond_to do |format|
      format.html {}
      format.js {@response}
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :licensor_id, :role, { widgets: [] })
  end
end
