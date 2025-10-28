# Catalogue manages product lookups
class Catalogue
  def initialize(products)
    @products = products.each_with_object({}) { |p, h| h[p.code] = p }
  end

  def find(code)
    @products[code] || raise(ArgumentError, "Unknown product code: #{code}")
  end
end