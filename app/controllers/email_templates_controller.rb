class EmailTemplatesController < ApplicationController
  before_action :set_parent_and_email_template
  before_action :set_email_template, only: [:update]

  def create

    @email_template = @parent.email_templates.new(template_params)
    if @email_template.save
      flash[:notice] = "Template Saved Successfully"
    else
      flash[:alert] = @email_template.errors.full_messages.to_sentence
    end
    # klass.constantize
    # authorize @licensor
    # get_body_and_emails_for_sent_email

    # if params[:commit] == 'send_email'
    #   flash[:notice] = "Email will be sent shortly."
    # elsif params[:commit] == 'preview'
    #   # email_data =
    #   # email_data[:subject]
    #   # email_data[:email]
    #   # email_data[:]
    #   puts CeaseAndDesistMailer.sent_email(SentEmail.new(params[:email_template][:sent_emails_attributes][:'0']))
    # elsif params[:commit] == 'save'
    #   if @email_template.update(template_params)
    #     flash[:notice] = "Template Was Successfully Saved."
    #   else
    #     flash[:alert] = @email_template.errors.full_messages.to_sentence
    #   end
    #   # @email_template.save
    #   respond_to do |format|
    #     format.js { }
    #   end
    # end
    redirect_back(fallback_location: :back)
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
      params.require(:email_template).permit(:text, :default_subject, :template_type, { sent_emails_attributes: [
        :id,
        :email_template_id,
        :subject,
        :email,
        :cc_emails,
        :template_type,
        :body,
        :brand_id,
        :brand_logo_id,
        :domain_id,
        :user_id,
        :_destroy] })
    end

    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end
    def set_parent_and_email_template
      @parent = params[:email_template][:parent_type].constantize.find(params[:email_template][:parent_id])
      @email_template = @parent.email_templates.any? ? @parent.email_templates : @parent.email_templates.new
    end

    def get_body_and_emails_for_sent_email
      sent_email_params = params[:email_template][:sent_emails_attributes][:'0']

      brand = @parent.brands.find(sent_email_params[:brand_id]) if @parent.class.name == 'Licensor' and sent_email_params[:brand_id].present?
      brand_name = brand.try(:name)
      licensor_name = @parent.name if @parent.class == 'Licensor'
      brand_logo = brand.logos.find(sent_email_params[:brand_logo_id])
      trademark_registration_number = brand_logo.try(:trademark_registration_number)
      trademark_registration_location = brand_logo.try(:trademark_registration_location)
      trademark_registration_category = brand_logo.try(:trademark_registration_category)
      trademark_registration_url = brand_logo.try(:trademark_registration_url)
      domain = Domain.find(sent_email_params[:domain_id])
      domain_name = domain.try(:name)
      email = domain.try(:owner_email)
      licensor_name = @parent.try(:name)


      body = params[:email_template][:text]
      subject = params[:email_template][:default_subject]
      params[:email_template][:sent_emails_attributes][:'0'][:body] = body.gsub('[TRADEMARK_REGISTRATION_NUMBER]', "#{trademark_registration_number.present? ? trademark_registration_number : [TRADEMARK_REGISTRATION_NUMBER]}")
      .gsub('[TRADEMARK_REGISTRATION_LOCATION]', "#{trademark_registration_location.present? ? trademark_registration_location : [TRADEMARK_REGISTRATION_LOCATION]}")
      .gsub('[TRADEMARK_REGISTRATION_CATEGORY]', "#{trademark_registration_category.present? ? trademark_registration_category : [TRADEMARK_REGISTRATION_CATEGORY]}")
      .gsub('[TRADEMARK_REGISTRATION_URL]', "#{trademark_registration_url.present? ? trademark_registration_url : [TRADEMARK_REGISTRATION_URL]}")
      .gsub('[BRAND_NAME]', "#{brand_name.present? ? brand_name : [BRAND_NAME]}")
      .gsub('[LICENSOR_NAME]', "#{licensor_name.present? ? licensor_name : [LICENSOR_NAME]}")
      .gsub('[DOMAIN_NAME]', "#{domain_name.present? ? domain_name : [DOMAIN_NAME]}")

      params[:email_template][:sent_emails_attributes][:'0'][:email] = email
      params[:email_template][:sent_emails_attributes][:'0'][:subject] = subject


    end
end

