class AssignedDomainsController < ApplicationController
  before_action :set_user, only: [ :create, :destroy ]
  before_action :set_assigned_domain, only: [ :destroy ]

  def create
    authorize AssignedDomain
    assigned_domains = @user.assigned_domains.build(domain_id: params[:assigned_domain_id])
    if assigned_domains.save
      @response = true
    else
      @response = assigned_domains.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.js {@response}
    end
  end

  def destroy
    authorize @assigned_domain
    @assigned_domain.destroy
    redirect_to edit_user_path(@user), notice: 'Domain was successfully Unassigned.'
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_assigned_domain
      @assigned_domain = @user.assigned_domains.find_by_domain_id(params[:id])
    end
end
