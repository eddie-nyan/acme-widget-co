# Buy one red widget, get second half price
class BuyOneGetSecondHalfPriceOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items, catalogue)
    matching_items = items.select { |code| code == @product_code }
    return 0.0 if matching_items.size < 2

    product = catalogue.find(@product_code)
    pairs = matching_items.size / 2
    
    # Discount is half price on second item in each pair
    pairs * (product.price / 2.0)
  end
end