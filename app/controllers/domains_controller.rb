class DomainsController < ApplicationController
  before_action :set_domain, only: [:destroy]

  def index
    authorize Domain
    @q = policy_scope(Domain).user_domains(current_user.id).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @domains = @q.result

    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @status = params[:status]
    end
    @status ||= "blacklisted"

    @domains = @domains.public_send(@status).page(params[:page])
  end

  def create
    authorize Domain
    user_domain = current_user.domains.find_by(name: domain_params[:name])
    if user_domain.present? and user_domain.status == domain_params[:status]
      assigned_domain = current_user.assigned_domains.find_by(domain_id: user_domain.id)
      assigned_domain.destroy ? flash[:notice] = "Domain was successfully created." : flash[:alert] = "Domain was not Created"
    else

      @domain = Domain.new(domain_params)

      if @domain.save
        @domain.create_activity(:create, owner: current_user, parameters: { name: @domain.name })
        @domain.update_posts!
        flash[:notice] = "Domain was successfully created."
      else
        flash[:alert] = @domain.errors.full_messages.to_sentence
      end
    end
    redirect_back(fallback_location: domains_path)
  end

  def destroy
    authorize @domain
    if current_user.confirmed_client?
      current_user.assigned_domains.create(domain_id: @domain.id)
    elsif current_user.admin?
      @domain.create_activity(:destroy, owner: current_user, parameters: { name: @domain.name })
      @domain.destroy
    end
    flash[:notice] = "Domain was successfully destroyed."
    redirect_back(fallback_location: domains_path)
  end

  def change_status
    authorize Domain
    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domain = Domain.find(params[:domain_id])
      @domain.public_send("#{params[:status]}!")
      @domain.create_activity(params[:status], owner: current_user, parameters: { name: @domain.name })
      @domain.update_posts!
      flash[:notice] = "Domain status changed"
    end

    redirect_back(fallback_location: domains_path)
  end

  private

  def set_domain
    @domain = Domain.find(params[:id])
  end

  def domain_params
    params.require(:domain).permit(:name, :status)
  end
end
