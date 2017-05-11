class BrandLogosController < ApplicationController
  before_action :set_logo

  def show
    authorize BrandLogo
    @brand = @logo.brand
  end

  private
    def set_logo
      @logo = BrandLogo.find(params[:id])
    end
end
