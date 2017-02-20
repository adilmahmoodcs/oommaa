class DomainsController < ApplicationController
  def index
    @q = Domain.ransack(params[:q])
    @domains = @q.result.page(params[:page])
  end

  def change_status
    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domain = Domain.find(params[:domain_id])
      @domain.public_send("#{params[:status]}!")
    end

    redirect_to :back
  end
end
