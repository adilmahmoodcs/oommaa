module ApplicationHelper
  def auto_link(text)
    Rinku.auto_link(text, :all, 'target="_blank"').html_safe
  end
end
