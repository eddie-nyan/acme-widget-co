# frozen_string_literal: true

require_relative 'product'
require_relative 'catalogue'
require_relative 'delivery_charge_calculator'
require_relative 'offer'
require_relative 'offer_engine'
require_relative 'offers/buy_one_get_second_half_price_offer'
require_relative 'basket'

# Factory to create a configured basket
module BasketFactory
  def self.create_default
    products = [
      Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
      Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
      Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
    ]

    catalogue = Catalogue.new(products)

    delivery_rules = [
      { threshold: 90.0, charge: 0.0 },
      { threshold: 50.0, charge: 2.95 },
      { threshold: 0.0, charge: 4.95 }
    ]
    delivery_calculator = DeliveryChargeCalculator.new(delivery_rules)

    offers = [
      BuyOneGetSecondHalfPriceOffer.new('R01')
    ]
    offer_engine = OfferEngine.new(offers)

    Basket.new(
      catalogue: catalogue,
      delivery_calculator: delivery_calculator,
      offer_engine: offer_engine
    )
  end
end