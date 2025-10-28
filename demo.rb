#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/basket_factory'

# Demo script to run test cases
puts "Acme Widget Co - Basket System Demo\n\n"

test_cases = [
  { items: ['B01', 'G01'], expected: 37.85 },
  { items: ['R01', 'R01'], expected: 54.37 },
  { items: ['R01', 'G01'], expected: 60.85 },
  { items: ['B01', 'B01', 'R01', 'R01', 'R01'], expected: 98.27 }
]

test_cases.each_with_index do |test, index|
  basket = BasketFactory.create_default
  test[:items].each { |code| basket.add(code) }
  total = basket.total.round(2)
  
  status = total == test[:expected] ? '✓' : '✗'
  puts "Test #{index + 1}: #{test[:items].join(', ')}"
  puts "  Expected: $#{test[:expected]}"
  puts "  Got: $#{total}"
  puts "  #{status} #{total == test[:expected] ? 'PASS' : 'FAIL'}\n\n"
end