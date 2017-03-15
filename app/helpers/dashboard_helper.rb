module DashboardHelper
  def all_widgets
    root = Rails.root.join("app", "views", "dashboard", "widgets")
    extension = ".html.erb"
    Dir.glob("#{root}/_*#{extension}").map do |file|
      File.basename(file, extension).sub(/\A_/, "")
    end
  end

  def render_widget(name)
    render "dashboard/widgets/#{name}", name: name
  rescue ActionView::MissingTemplate
    "<!-- missing partial for #{name} -->".html_safe
  end

  def render_widgets
    widgets = current_user.admin? ? all_widgets : current_user.widgets
    widgets.map do |widget_name|
      render_widget(widget_name)
    end.join.html_safe
  end
end
