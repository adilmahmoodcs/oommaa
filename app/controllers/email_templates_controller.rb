class EmailTemplatesController < ApplicationController
  before_action :set_parent, only: [:create]
  before_action :set_email_template, only: [:update]

  def create
    @email_template = @parent.email_templates.new(template_params)
    if @email_template.save
      flash[:notice] = "Template Saved Successfully"
    else
      flash[:alert] = @email_template.errors.full_messages.to_sentence
    end
    if params[:send_email] == 'true'
      redirect_to cease_and_desist_email_licensor_path(@parent)
    else
      redirect_back(fallback_location: :back)
    end
  end

  def update
    if @email_template.update(template_params)
      flash[:notice] = "Template Successfully Updated"
    else
      flash[:alert] = @email_template.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: :back)
  end

  private
    def template_params
      params.require(:email_template).permit(:text, :default_subject, :template_type)
    end

    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end
    def set_parent
      @parent = params[:email_template][:parent_type].constantize.find(params[:email_template][:parent_id])
    end
end

