class KeywordMatcher
  def match?(term)
    term.match?(regexp)
  end

  private

  def keywords
    Keyword.pluck(:name)
  end

  def regexp
    @regexp ||= Regexp.union(keywords)
  end
end
