class EmployeeReportPresenter
  # attr_reader :employee, :link, :dropdown, :summary, :view_context
  attr_reader :employee, :emp_param, :view_context

  # delegate :design, :marketer_account, to: :campaign
  # delegate :format_date, :format_date_with_relative, :format_relative_time,
  #   :content_tag, :tooltip_help, :unknown_fulfillment_date, :pluralize,
  #   to: :view_context

  def initialize(view_context, employee, emp_param)
    @view_context = view_context
    @employee = employee
    @emp_param = emp_param
  end

  def has_many_association?
    associations = Employee.reflect_on_all_associations(:has_many)
    associations.any? { |a| a.name == association_name }
  end

  def has_one_association?
    flag = false
    associations = Employee.reflect_on_all_associations(:belongs_to)
    flag = associations.any? { |a| a.name == association_name }
    return flag if flag.present?
    associations = Employee.reflect_on_all_associations(:has_one)
    associations.any? { |a| a.name == association_name }
  end

  def own_field?
    employee.send(emp_param[0]).present?
  end

  def own_field_value
    employee.send(emp_param[0])
  end

  def own_field_key
    emp_param[0]
  end

  def associate_fields
    emp_param[1].to_a
  end

  def association_name
    emp_param[0].to_sym
  end

  def associate_data
    employee.send(association_name)
  end

  def associate_field_key(field)
    field[0]
  end

  def associate_field_value(record, field)
    record.send(associate_field_key(field))
  end

  # def link
  #   @campaign_link_presenter ||= CampaignLinkPresenter.new(
  #     view_context,
  #     campaign
  #   )
  # end

  # def dropdown
  #   @campaign_dropdown_presenter ||= CampaignDropdownPresenter.new(
  #     view_context,
  #     campaign
  #   )
  # end

  # def formatted_started_at
  #   format_date(campaign.started_at)
  # end

  # def fulfillment_date_info
  #   if campaign.creates_order_batch_on.present?
  #     content_tag(
  #       :span,
  #       format_date_with_relative(campaign.creates_order_batch_at, format: :short_with_day),
  #       class: "nowrap",
  #       title: campaign.creates_order_batch_at
  #     )
  #   else
  #     unknown_fulfillment_date(campaign)
  #   end
  # end

  # def fulfillment_frequency
  #   if Campaign::BATCH_DURATION_IN_HOURS.key?(campaign.batch_duration_in_hours)
  #     value = Campaign::BATCH_DURATION_IN_HOURS[campaign.batch_duration_in_hours]
  #     return value if value.present?

  #     # Empty when draft value hasn't been changed (8760)
  #     "Unknown&nbsp;".html_safe + tooltip_help("Fulfilment frequency set yet") # rubocop:disable Rails/OutputSafety
  #   else
  #     "Every #{pluralize(campaign.batch_duration_in_hours, 'hour')}"
  #   end
  # end

  # def first_order_info
  #   return "" unless campaign.current_order_batch.present?
  #   formatted_date = I18n.localize(campaign.current_order_batch.started_on, format: :short)
  #   tooltip_help(
  #     "First order placed #{formatted_date} (#{format_relative_time(campaign.current_order_batch.started_at)})"
  #   )
  # end
end
