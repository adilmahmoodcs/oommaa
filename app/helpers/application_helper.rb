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

  def logo_path
    "oommaa-logo.png"
  end

  def csv_export_params(params)
    params.to_hash if params
  end

  def filter_results data
    data.present? ? data.map {|data| [data[:text], data[:id]]} : []
  end

  def primary_color
    if current_user and current_user.primary_color.present?
      current_user.primary_color
    else
      "#ffffff"
    end
  end

  def secondary_color
    if current_user and current_user.secondary_color.present?
      current_user.secondary_color
    else
      "#797272"
    end
  end

  def post_logo_url url
    if Faraday.head(url).status == 200
      url
    else
      'startui/file-img.png'
    end
  end

  # oommaa work
  def link_to_add_fields(name, f, association, btn_classes='', fields_dir='')
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{fields_dir}#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields #{btn_classes}", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
