class LicensorsController < ApplicationController
  before_action :set_licensor, only: [:show, :edit, :update, :destroy,
                                      :cease_and_desist_email,
                                      :get_licensors_brands_info]

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
    @email_template = @licensor.email_templates.any? ? @licensor.email_templates.take : @licensor.email_templates.new
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
    if  @licensor.email_templates.any?
      @brands = @licensor.brands
      @email_template = @licensor.email_templates.take
      @sent_email = @email_template.sent_emails.new
      @domains = policy_scope(Domain).blacklisted.where.not("owner_email = ?", 'NULL')
    else
      redirect_to edit_licensor_path(@licensor)+"?send_email=true", alert: 'Add Template First.'
    end
  end

  def get_licensors_brands_info
    @brand = @licensor.try(:brands).find(params[:brand_id])
    @logos = @brand.logos if @brand

    respond_to do |format|
      format.js { }
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
