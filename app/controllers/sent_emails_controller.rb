class SentEmailsController < ApplicationController
  before_action :set_email_template, only: [:create, :preview]

  def create
    @email = @email_template.sent_emails.new(email_params)
    if @email.save
      flash[:notice] = "Secessfully sent Email to domain email"
    else
      flash[:alert] = @email.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: :back)
  end

  def preview
    if params[:sent_email][:brand_logo_id].present? and @brand_logo = BrandLogo.find(params[:sent_email][:brand_logo_id])
      @record_found = true
      @brand = @brand_logo.brand
      @licensor = @brand.licensor
      @body = build_body_for_email.html_safe
    else
      @record_found = false
    end
    respond_to do |format|
      format.js {@body}
    end
  end

  private
    def email_params
      params.require(:sent_email).permit(:id, :email_template_id, :subject, :email,
                                         :cc_emails, :body, :brand_id, :brand_logo_id,
                                         :domain_id, :user_id)
    end

    def set_email_template
      @email_template = EmailTemplate.find(params[:email_template_id])
    end

    def build_body_for_email
      body = @email_template.text
      number = @brand_logo.try(:trademark_registration_number) || "[TRADEMARK_REGISTRATION_NUMBER]"
      location = @brand_logo.try(:trademark_registration_location) || "[TRADEMARK_REGISTRATION_LOCATION]"
      category = @brand_logo.try(:trademark_registration_category) || "[TRADEMARK_REGISTRATION_CATEGORY]"
      url = @brand_logo.try(:trademark_registration_url) || "[TRADEMARK_REGISTRATION_URL]"
      licensor_name = @licensor.try(:name) || "[LICENSOR_NAME]"
      brand_name = @brand.try(:name) || "[BRAND_NAME]"


      body.gsub('[TRADEMARK_REGISTRATION_NUMBER]', number)
      .gsub('[TRADEMARK_REGISTRATION_LOCATION]', location)
      .gsub('[TRADEMARK_REGISTRATION_CATEGORY]', category)
      .gsub('[TRADEMARK_REGISTRATION_URL]', url)
      .gsub('[BRAND_NAME]', brand_name)
      .gsub('[LICENSOR_NAME]', licensor_name)


    end
end
