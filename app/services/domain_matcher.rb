class DomainMatcher
  attr_reader :status

  def initialize(status: "blacklisted")
    @status = status
  end

  def match?(terms)
    terms.any? do |term|
      names.include? term
    end
  end

  def match_all?(terms)
    terms.any? && terms.all? do |term|
      names.include? term
    end
  end

  private

  def names
    Domain.public_send(status).pluck(:name).map(&:downcase)
  end
end
