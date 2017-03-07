class LicensorsController < ApplicationController
  before_action :set_licensor, only: [:show, :edit, :update, :destroy]

  def index
    authorize Licensor
    @q = policy_scope(Licensor).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @licensors = @q.result.page(params[:page])
  end

  def show
    authorize @licensor
  end

  def new
    authorize Licensor
    @licensor = Licensor.new
  end

  def edit
    authorize @licensor
  end

  def create
    authorize Licensor
    @licensor = Licensor.new(licensor_params)

    if @licensor.save
      redirect_to licensors_path, notice: 'Licensor was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @licensor
    if @licensor.update(licensor_params)
      redirect_to licensors_path, notice: 'Licensor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @licensor
    @licensor.destroy
    redirect_to licensors_path, notice: 'Licensor was successfully destroyed.'
  end

  private

  def set_licensor
    @licensor = Licensor.find(params[:id])
  end

  def licensor_params
    params.require(:licensor).permit(:name, :main_contact, :logo)
  end
end
