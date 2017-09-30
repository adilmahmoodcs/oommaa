class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  def index
    authorize Role
    @q = policy_scope(Role).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @roles = @q.result.
                 page(params[:page])
  end

  def show
    authorize @role
  end

  def new
    authorize Role
    @role = Role.new
  end

  def edit
    authorize @role
  end

  def create
    authorize Role
    @role = Role.new(role_params)

    if @role.save
      set_rights
      @role.create_activity(:create, owner: current_user, parameters: { name: @role.name })
      redirect_to roles_path, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @role
    if @role.update(role_params)
      set_rights
      @role.create_activity(:update, owner: current_user, parameters: { name: @role.name })
      redirect_to roles_path, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @role
    @role.create_activity(:destroy, owner: current_user, parameters: { name: @role.name })
    @role.destroy
    redirect_to roles_path, notice: 'Role was successfully destroyed.'
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :right_ids)
  end

  def set_rights
    params[:right_ids].each do |right_id, result|
      if result.to_s=='true'
        RoleRight.find_or_create_by(right_id: right_id, role_id: params[:id])
      else
        RoleRight.where(right_id: right_id, role_id: params[:id]).delete_all
      end
    end
  end

end
