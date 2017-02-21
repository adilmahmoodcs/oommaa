class DomainsController < ApplicationController
  def index
    @q = Domain.ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @domains = @q.result

    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domains = @domains.public_send(params[:status])
      @status = params[:status]
    end

    @domains = @domains.page(params[:page])
  end

  def change_status
    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domain = Domain.find(params[:domain_id])
      @domain.public_send("#{params[:status]}!")
    end

    redirect_to :back
  end
end
