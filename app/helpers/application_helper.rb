module ApplicationHelper
  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"').html_safe
  end

  def render_if_exists(path, *args)
    render path, *args
  rescue ActionView::MissingTemplate
    if args.first && fallback = args.first[:fallback].presence
      render fallback
    end
  end

  def date_filter_options_for(field_name)
    options_for_select([
      ["Yesterday", Date.yesterday.beginning_of_day],
      ["Last 7 days", 7.days.ago.beginning_of_day],
      ["Last 30 days", 30.days.ago.beginning_of_day],
    ], params[:q][field_name])
  end

  def ad_screenshot_links(post)
    post.ad_screenshots.each_with_index.map do |screenshot, i|
      name = i > 0 ? "Link #{i.succ}" : "Link"
      link_to name, screenshot.image.url, target: "_blank"
    end.join("<br>").html_safe
  end

  def product_screenshot_links(post)
    post.product_screenshots.each_with_index.map do |screenshot, i|
      name = i > 0 ? "Link #{i.succ}" : "Link"
      link_to name, screenshot.image.url, target: "_blank"
    end.join("<br>").html_safe
  end
end
