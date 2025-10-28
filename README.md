# Acme Widget Co - Shopping Basket System

A flexible, extensible shopping basket implementation demonstrating good Ruby practices, design patterns, and clean architecture.

## Overview

This system calculates basket totals including:
- Product pricing
- Special offers (e.g., buy one get second half price)
- Dynamic delivery charges based on order value

## Architecture

### Design Principles

**Separation of Concerns**: Each class has a single, well-defined responsibility
- `Product`: Represents catalogue items
- `Catalogue`: Manages product lookups
- `DeliveryChargeCalculator`: Applies delivery rules
- `Offer`/`OfferEngine`: Handles promotional discounts
- `Basket`: Orchestrates the pricing flow

**Dependency Injection**: The `Basket` class receives its dependencies rather than creating them, making it testable and flexible.

**Strategy Pattern**: Offers are implemented as strategies that can be composed and extended without modifying core basket logic.

**Open/Closed Principle**: New offers can be added by creating new `Offer` subclasses without changing existing code.

### Key Classes

#### `Basket`
Main interface for adding products and calculating totals. Injected with:
- `Catalogue` for product lookups
- `DeliveryChargeCalculator` for delivery charges
- `OfferEngine` for promotional discounts

#### `Catalogue`
Validates product codes and retrieves product information.

#### `DeliveryChargeCalculator`
Applies threshold-based delivery rules. Rules are data-driven and easily configurable.

#### `Offer` Hierarchy
Base class defining the offer interface. Current implementation:
- `BuyOneGetSecondHalfPriceOffer`: Applies 50% discount to every second item of a specific product

#### `OfferEngine`
Composes multiple offers and calculates total discount.

#### `BasketFactory`
Creates configured basket instances with default products, delivery rules, and offers.

## Usage

### Running the Demo

```bash
ruby demo.rb
```

This runs the 18 test cases from the specification and displays results.

### Using in Code

```ruby
# Create a basket with default configuration
basket = BasketFactory.create_default

# Add products
basket.add('R01')  # Red Widget
basket.add('G01')  # Green Widget

# Get total
total = basket.total  # => 60.85
```

### Custom Configuration

```ruby
# Define products
products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95)
]
catalogue = Catalogue.new(products)

# Configure delivery rules
delivery_rules = [
  { threshold: 90.0, charge: 0.0 },
  { threshold: 50.0, charge: 2.95 },
  { threshold: 0.0, charge: 4.95 }
]
delivery_calculator = DeliveryChargeCalculator.new(delivery_rules)

# Set up offers
offers = [
  BuyOneGetSecondHalfPriceOffer.new('R01')
]
offer_engine = OfferEngine.new(offers)

# Create basket
basket = Basket.new(
  catalogue: catalogue,
  delivery_calculator: delivery_calculator,
  offer_engine: offer_engine
)
```

## Extending the System

### Adding New Offers

Create a new class inheriting from `Offer`:

```ruby
class BuyTwoGetOneFreeOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items, catalogue)
    matching = items.select { |code| code == @product_code }
    free_items = matching.size / 3
    product = catalogue.find(@product_code)
    free_items * product.price
  end
end
```

Then add it to the offer engine:

```ruby
offers = [
  BuyOneGetSecondHalfPriceOffer.new('R01'),
  BuyTwoGetOneFreeOffer.new('B01')
]
```

### Modifying Delivery Rules

Simply update the rules array:

```ruby
delivery_rules = [
  { threshold: 100.0, charge: 0.0 },   # Free over $100
  { threshold: 75.0, charge: 1.95 },   # $1.95 for $75-$99.99
  { threshold: 50.0, charge: 3.95 },   # $3.95 for $50-$74.99
  { threshold: 0.0, charge: 5.95 }     # $5.95 under $50
]
```

## Assumptions

1. **Offer Application Order**: Offers are applied independently and discounts are summed. If multiple offers affect the same items, they don't conflict.

2. **Delivery Calculation**: Delivery charges are based on the discounted subtotal (after offers), not the pre-discount amount.

3. **Rounding**: Prices are handled as floats. For production, consider using `BigDecimal` for precise currency calculations.

4. **Product Validation**: Invalid product codes raise an `ArgumentError` immediately when added to the basket.

5. **Offer Logic**: The "buy one get second half price" offer applies to pairs. With 5 red widgets, 2 pairs get the discount (4 widgets affected), and 1 remains full price.

## Future Enhancements

- Multi-buy offers (e.g., "3 for $10")
- Percentage-based discounts
- Coupon codes
- Tax calculations
- Currency handling with `BigDecimal`
- Persistence layer
- Basket serialization
- Stock management integration

## Requirements

- Ruby 2.7+
- No external dependencies for core functionality