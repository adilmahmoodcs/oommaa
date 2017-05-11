class LicensorsController < ApplicationController
  before_action :set_licensor, only: [:show, :edit, :update, :destroy,
                                      :cease_and_desist_email,
                                      :send_cease_and_desist_email, :get_licensors_brands_info]

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

  def search
    authorize Licensor
    data = DefaultSearchFilter.new(term: params[:term], page: params[:page] ).call('Licensor', current_user)
    render json: { results: data[:results], size: data[:size] }
  end

  def cease_and_desist_email
    authorize @licensor
    @brands = @licensor.brands
    @domains = policy_scope(Domain).blacklisted.where.not("owner_email = ?", 'NULL')
  end

  def get_licensors_brands_info
    @brand = @licensor.try(:brands).find(params[:licensor][:brands])
    @logos = @brand.logos if @brand

    respond_to do |format|
      format.js { }
    end
  end

  def send_cease_and_desist_email
    authorize @licensor
    @licensor.update(licensor_params)
    if params[:commit] == 'send_email'
    elsif params[:commit] == 'save'
    end

  end

  private

  def set_licensor
    @licensor = Licensor.find(params[:id])
  end

  def licensor_params
    params.require(:licensor).permit(:name, :main_contact, :logo, :cease_and_desist_template, :cease_and_desist_subject)
  end
end
