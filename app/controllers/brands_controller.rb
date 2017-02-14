class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  # GET /brands
  def index
    @brands = Brand.all
  end

  # GET /brands/1
  def show
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands
  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      @brand.create_activity(:create, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /brands/1
  def update
    if @brand.update(brand_params)
      @brand.create_activity(:update, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /brands/1
  def destroy
    @brand.create_activity(:destroy, owner: current_user, parameters: { name: @brand.name })
    @brand.destroy
    redirect_to brands_path, notice: 'Brand was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def brand_params
      params.require(:brand).permit(:name)
    end
end
