class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize User
    @q = policy_scope(User).ransack(params[:q])
    @q.sorts = "id DESC" if @q.sorts.empty?
    @users = @q.result.
                page(params[:page])
  end

  def new
    authorize User
    @user = User.new
  end

  def create
    authorize User
    @user = User.new(user_params)
    params[:user][:confirmed_at] = Time.current

    if @user.save(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    is_valid = false
    change_password = true
    user_update_params = nil

    if params[:user][:password].blank?
      params[:user].delete("password")
      change_password = false
      user_update_params = params.require(:user).permit(:name, :email, role_ids: [])
    else
      params[:user][:confirmed_at] = Time.current
      user_update_params = params.require(:user).permit(:name, :email, :password, :confirmed_at, role_ids: [])
    end
    if change_password.present?
      is_valid = @user.update(user_update_params)
    else
      is_valid = @user.update_without_password(user_update_params)
    end

    if is_valid
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
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
    params.require(:user).permit(:name, :email, :password, :confirmed_at, role_ids: [])
  end

end
