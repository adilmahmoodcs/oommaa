class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    @q = Brand.ransack(params[:q])
    @brands = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @brand = Brand.new
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      @brand.create_activity(:create, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully created.'
    else
      render :new
    end
  end

  def update
    if @brand.update(brand_params)
      @brand.create_activity(:update, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @brand.create_activity(:destroy, owner: current_user, parameters: { name: @brand.name })
    @brand.destroy
    redirect_to brands_path, notice: 'Brand was successfully destroyed.'
  end

  private

  def set_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name, :logo)
  end
end
