class DomainsController < ApplicationController
  def index
    @q = Domain.ransack(params[:q])
    @domains = @q.result.page(params[:page])
  end
end
