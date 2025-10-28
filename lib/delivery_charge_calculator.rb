# Strategy pattern for delivery charge calculation
class DeliveryChargeCalculator
  def initialize(rules)
    @rules = rules.sort_by { |r| r[:threshold] }.reverse
  end

  def calculate(subtotal)
    rule = @rules.find { |r| subtotal >= r[:threshold] }
    rule ? rule[:charge] : 0.0
  end
end