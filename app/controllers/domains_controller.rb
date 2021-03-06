class DomainsController < ApplicationController
  before_action :set_domain, only: [:destroy, :update]

  def index
    authorize Domain
    @q = policy_scope(Domain).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @domains = @q.result

    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @status = params[:status]
    end
    @status ||= "blacklisted"

    @domains = @domains.public_send(@status).page(params[:page])
  end

  def create
    authorize Domain

    valid_domain_name = validate_domain_name domain_params[:name]
    requested_domain = Domain.find_by(name: valid_domain_name)

    if current_user.confirmed_client? and requested_domain.present? and requested_domain.status == domain_params[:status]
      assigned_domain = current_user.assigned_domains.build(domain: requested_domain)
      assigned_domain.save ? flash[:notice] = "Domain was successfully created." : flash[:alert] = assigned_domain.errors.full_messages.to_sentence
    elsif current_user.confirmed_client? and requested_domain.present? and requested_domain.status != domain_params[:status]
      flash[:alert] = "Domain is already present with #{requested_domain.status} please request admin for this domain here:
                #{view_context.link_to(" Request Domain", client_domain_request_user_path(current_user, domain_id: requested_domain.id)).html_safe}."
    elsif valid_domain_name
      params[:domain][:name] = valid_domain_name.to_s
      @domain = Domain.new(domain_params)
      if @domain.save
        @domain.create_activity(:create, owner: current_user, parameters: { name: @domain.name })
        @domain.update_posts!
        flash[:notice] = "<strong>#{valid_domain_name} </strong> was successfully created with given url.".html_safe
      else
        flash[:alert] = "<strong>#{valid_domain_name} </strong> is already taken".html_safe
      end
    else
      flash[:alert] = "Invalid Domain (#{domain_params[:name]})"
    end
    redirect_back(fallback_location: domains_path)
  end

  def update
    if params[:domain][:owner_email].present? and @domain.update_email(params[:domain][:owner_email])
      flash[:notice] = "Email successfully added for #{@domain.name}"
    else
      flash[:alert] = @domain.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: domains_path)
  end

  def destroy
    authorize @domain
    if current_user.confirmed_client?
      current_user.assigned_domains.find_by(domain_id: @domain.id).destroy
    elsif current_user.admin?
      @domain.create_activity(:destroy, owner: current_user, parameters: { name: @domain.name })
      @domain.destroy
    end
    flash[:notice] = "Domain was successfully destroyed."
    redirect_back(fallback_location: domains_path)
  end

  def change_status
    authorize Domain
    if params[:status] && params[:status].in?(Domain.statuses.keys)
      @domain = Domain.find(params[:domain_id])
      @domain.public_send("#{params[:status]}!")
      @domain.create_activity(params[:status], owner: current_user, parameters: { name: @domain.name })
      @domain.update_posts!
      flash[:notice] = "Domain status changed"
    end

    redirect_back(fallback_location: domains_path)
  end

  private

  def set_domain
    @domain = Domain.find(params[:id])
  end

  def domain_params
    params.require(:domain).permit(:name, :status, :owner_email)
  end

  def validate_domain_name url
    url_regex = (/^(http|https):\/\/+[\www]+[a-z0-9]+([\_\.\-]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix)
    domain_regex = (/^[a-z0-9]+([\-\.\_]{1}[a-z0-9]+)*\.[a-z]{2,5}$/ix)
    if url.match? url_regex
      uri = URI.parse(url)
      begin
        return PublicSuffix.parse(uri.host).domain
      rescue PublicSuffix::DomainInvalid
        return false
      end
    elsif url.match? domain_regex
      url.sub(/^www./,'')
    end
  end
end
