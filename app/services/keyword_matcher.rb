class KeywordMatcher
  def match?(term)
    term.to_s.match?(regexp)
  end

  private

  def keywords
    Keyword.pluck(:name)
  end

  def regexp
    @regexp ||= Regexp.union(keywords)
  end
end
