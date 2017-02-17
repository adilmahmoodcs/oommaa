class DomainMatcher
  attr_reader :status

  def initialize(status: "blacklisted")
    @status = status
  end

  def match?(terms)
    terms.any? do |term|
      term.to_s.match?(regexp)
    end
  end

  private

  def names
    Domain.public_send(status).pluck(:name)
  end

  def regexp
    @regexp ||= Regexp.union(names)
  end
end
