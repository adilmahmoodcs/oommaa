# return ids of Brands that matches the term
class BrandMatcher
  attr_reader :term

  def initialize(term)
    @term = term
  end

  def call
    brand_ids = []
    Brand.find_each do |brand|
      if term.downcase.match? regexp_for(brand)
        brand_ids << brand.id
      end
    end

    brand_ids
  end

  private

  def regexp_for(brand)
    fields = [
      brand.name
    ].map(&:downcase)
    Regexp.union(fields)
  end
end
