# return ids of Brands that matches the term
class BrandMatcher
  attr_reader :term

  def initialize(term)
    @term = term.downcase
  end

  def call
    brand_ids = []
    Brand.select(:id, :name, :nicknames).find_each do |brand|
      if term.match? regexp_for(brand)
        brand_ids << brand.id
      end
    end

    brand_ids
  end

  private

  def regexp_for(brand)
    fields = ([brand.name] + brand.nicknames).map(&:downcase)
    Regexp.union(fields)
  end
end
