class DefaultSearchFilter
  attr_reader :term, :page, :per_page

  def initialize(term: , page: 1, per_page: 25)
    @term = term
    @page = page
    @per_page = per_page
  end

  def call(klass, current_user)
    if term.is_a?(Hash)
      term_to_search = klass.constantize.find_by(id: term[:id]).try(:name)
    else
      term_to_search = term
    end
    data = Pundit.policy_scope(current_user, klass.constantize).
                  select(:id, :name).
                  order("LOWER(name)").
                  ransack(name_cont: term_to_search).
                  result.
                  page(page).
                  per(per_page)
    results = data.map do |item| {
        id: item.id,
        text: item.name
      }
    end

    total_count = data.total_count
    {results: results, size: total_count}
  end
end
