class LicensorsController < ApplicationController
  before_action :set_licensor, only: [:show, :edit, :update, :destroy]

  def index
    @q = Licensor.ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @licensors = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @licensor = Licensor.new
  end

  def edit
  end

  def create
    @licensor = Licensor.new(licensor_params)

    if @licensor.save
      redirect_to licensors_path, notice: 'Licensor was successfully created.'
    else
      render :new
    end
  end

  def update
    if @licensor.update(licensor_params)
      redirect_to licensors_path, notice: 'Licensor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @licensor.destroy
    redirect_to licensors_path, notice: 'Licensor was successfully destroyed.'
  end

  private

  def set_licensor
    @licensor = Licensor.find(params[:id])
  end

  def licensor_params
    params.require(:licensor).permit(:name)
  end
end
