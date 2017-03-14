class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    authorize Brand
    @q = policy_scope(Brand).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @brands = @q.result.
                 includes(:licensor).
                 page(params[:page])
  end

  def show
    authorize @brand
  end

  def new
    authorize Brand
    @brand = Brand.new
    @brand.logos.new
  end

  def edit
    authorize @brand
    @brand.logos.new
  end

  def create
    authorize Brand
    @brand = Brand.new(brand_params)

    if @brand.save
      @brand.create_activity(:create, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @brand
    if @brand.update(brand_params)
      @brand.create_activity(:update, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @brand
    @brand.create_activity(:destroy, owner: current_user, parameters: { name: @brand.name })
    @brand.destroy
    redirect_to brands_path, notice: 'Brand was successfully destroyed.'
  end

  def search
    authorize Brand
    data = policy_scope(Brand).select(:id, :name).
                               order("LOWER(name)").
                               ransack(name_cont: params[:term]).
                               result.
                               map do |item|
                                 {
                                   id: item.id,
                                   text: item.name
                                 }
                               end

    render json: { results: data }
  end

  private

  def set_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(
      :name, :licensor_id, { nicknames: [] },
      { logos_attributes: [:image, :id, :_destroy] }
    )
  end
end
