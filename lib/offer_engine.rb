# Applies multiple offers to basket items
class OfferEngine
  def initialize(offers = [])
    @offers = offers
  end

  def calculate_discount(items, catalogue)
    @offers.sum { |offer| offer.apply(items, catalogue) }
  end
end