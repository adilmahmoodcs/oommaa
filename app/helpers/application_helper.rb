module ApplicationHelper
  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"').html_safe
  end

  def render_if_exists(path, *args)
    render path, *args
  rescue ActionView::MissingTemplate
    render args.first[:fallback]
  end

  def date_filter_options_for(field_name)
    options_for_select([
      ["Yesterday", Date.yesterday.beginning_of_day],
      ["Last 7 days", 7.days.ago.beginning_of_day],
      ["Last 30 days", 30.days.ago.beginning_of_day],
    ], params[:q][field_name])
  end
end
