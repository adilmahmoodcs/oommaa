module ApplicationHelper
  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"').html_safe
  end

  def render_if_exists(path, *args)
    render path, *args
  rescue ActionView::MissingTemplate
    render args.first[:fallback]
  end
end
