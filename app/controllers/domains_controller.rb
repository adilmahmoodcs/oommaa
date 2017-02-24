class DomainsController < ApplicationController
  before_action :set_domain, only: [:destroy]

  def index
    @q = Domain.ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @domains = @q.result

    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @status = params[:status]
    end
    @status ||= "blacklisted"

    @domains = @domains.public_send(@status).page(params[:page])
  end

  def create
    @domain = Domain.new(domain_params)

    if @domain.save
      @domain.create_activity(:create, owner: current_user, parameters: { name: @domain.name })
      @domain.update_posts!
      flash[:notice] = "Domain was successfully created."
    end

    redirect_back(fallback_location: domains_path)
  end

  def destroy
    @domain.create_activity(:destroy, owner: current_user, parameters: { name: @domain.name })
    @domain.destroy
    flash[:notice] = "Domain was successfully destroyed."
    redirect_back(fallback_location: domains_path)
  end

  def change_status
    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domain = Domain.find(params[:domain_id])
      @domain.public_send("#{params[:status]}!")
      @domain.update_posts!
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
