# Main basket class that orchestrates pricing
class Basket
  def initialize(catalogue:, delivery_calculator:, offer_engine:)
    @catalogue = catalogue
    @delivery_calculator = delivery_calculator
    @offer_engine = offer_engine
    @items = []
  end

  def add(product_code)
    @catalogue.find(product_code) # Validates product exists
    @items << product_code
  end

  def total
    subtotal = calculate_subtotal
    discount = @offer_engine.calculate_discount(@items, @catalogue)
    discounted_subtotal = subtotal - discount
    delivery = @delivery_calculator.calculate(discounted_subtotal)
    
    discounted_subtotal + delivery
  end

  private

  def calculate_subtotal
    @items.sum { |code| @catalogue.find(code).price }
  end
end