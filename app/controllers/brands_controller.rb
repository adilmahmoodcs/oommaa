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
  end

  def edit
    authorize @brand
  end

  def create
    authorize Brand
    params[:brand][:licensor_id] = current_user.licensor.id if current_user.confirmed_client?
    @brand = Brand.new(brand_params)

    if @brand.save
      params[:multiple_logos].each do |logo|
        @brand.logos.create(image: logo)
      end if params[:multiple_logos]
      @brand.create_activity(:create, owner: current_user, parameters: { name: @brand.name })
      redirect_to brands_path, notice: 'Brand was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @brand
    if @brand.update(brand_params)
      params[:multiple_logos].each do |logo|
        @brand.logos.create(image: logo)
      end if params[:multiple_logos]
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
    data = DefaultSearchFilter.new(term: params[:term], page: params[:page] ).call('Brand', current_user)
    render json: { results: data[:results], size: data[:size] }
  end

  private

  def set_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(
      :name, :licensor_id, { nicknames: [] },
      { logos_attributes: [
        :id,
        :trademark_registration_number,
        :trademark_registration_location,
        :trademark_registration_category,
        :trademark_registration_url,
        :image,
        :_destroy] }
    )
  end
end
