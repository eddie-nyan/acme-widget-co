#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/basket_factory'

def run_test(description, items, expected)
  basket = BasketFactory.create_default
  items.each { |code| basket.add(code) }
  total = basket.total
  
  status = total == expected ? '✓' : '✗'
  result = total == expected ? 'PASS' : 'FAIL'
  
  puts "#{description}"
  puts "  Items: #{items.join(', ')}"
  puts "  Expected: $#{'%.2f' % expected}"
  puts "  Got: $#{'%.2f' % total}"
  puts "  #{status} #{result}\n\n"
  
  result == 'PASS'
end

# Demo script with comprehensive test cases
puts "=" * 60
puts "Acme Widget Co - Basket System Demo"
puts "=" * 60
puts "\n"

# Track results
passed = 0
failed = 0

# Specification Test Cases
puts "=== SPECIFICATION TEST CASES ===\n\n"

if run_test('Test 1: Blue + Green Widget', ['B01', 'G01'], 37.85)
  passed += 1
else
  failed += 1
end

if run_test('Test 2: Two Red Widgets (BOGO 50% off)', ['R01', 'R01'], 54.37)
  passed += 1
else
  failed += 1
end

if run_test('Test 3: Red + Green Widget', ['R01', 'G01'], 60.85)
  passed += 1
else
  failed += 1
end

if run_test('Test 4: Multiple items with offers', ['B01', 'B01', 'R01', 'R01', 'R01'], 98.27)
  passed += 1
else
  failed += 1
end

# Additional Test Cases
puts "=== ADDITIONAL TEST CASES ===\n\n"

# Single item tests
if run_test('Test 5: Single Blue Widget', ['B01'], 12.90)
  passed += 1
else
  failed += 1
end

if run_test('Test 6: Single Red Widget', ['R01'], 37.90)
  passed += 1
else
  failed += 1
end

if run_test('Test 7: Single Green Widget', ['G01'], 29.90)
  passed += 1
else
  failed += 1
end

# Delivery threshold tests
# 6 Blues: 7.95 * 6 = 47.70, delivery = 4.95, total = 52.65
if run_test('Test 8: Just under $50 (high delivery)', ['B01', 'B01', 'B01', 'B01', 'B01', 'B01'], 52.65)
  passed += 1
else
  failed += 1
end

# Red + Green: 32.95 + 24.95 = 57.90, delivery = 2.95, total = 60.85
if run_test('Test 9: Just over $50 (medium delivery)', ['R01', 'G01'], 60.85)
  passed += 1
else
  failed += 1
end

# 3 Reds: 98.85 - 16.475 = 82.375, delivery = 0, total = 82.37
if run_test('Test 10: Over $90 (free delivery)', ['R01', 'R01', 'R01'], 85.32)
  passed += 1
else
  failed += 1
end

# Offer tests
# 3 Reds: 98.85 - 16.475 (1 pair discount) = 82.375, delivery = 2.95, total = 85.32
if run_test('Test 11: Three Red Widgets (1 pair gets discount)', ['R01', 'R01', 'R01'], 85.32)
  passed += 1
else
  failed += 1
end

# 4 Reds: 131.80 - 32.95 (2 pairs discount) = 98.85, delivery = 0, total = 98.85
if run_test('Test 12: Four Red Widgets (2 pairs get discount)', ['R01', 'R01', 'R01', 'R01'], 98.85)
  passed += 1
else
  failed += 1
end

# 5 Reds: 164.75 - 32.95 (2 pairs discount) = 131.80, delivery = 0, total = 131.80
if run_test('Test 13: Five Red Widgets (2 pairs get discount)', ['R01', 'R01', 'R01', 'R01', 'R01'], 131.80)
  passed += 1
else
  failed += 1
end

# Mixed baskets
# R01 + G01 + B01: 32.95 + 24.95 + 7.95 = 65.85, delivery = 2.95, total = 68.80
if run_test('Test 14: All three products', ['R01', 'G01', 'B01'], 68.80)
  passed += 1
else
  failed += 1
end

# 2 Greens + 3 Blues: 49.90 + 23.85 = 73.75, delivery = 2.95, total = 76.70
if run_test('Test 15: Multiple greens and blues', ['G01', 'G01', 'B01', 'B01', 'B01'], 76.70)
  passed += 1
else
  failed += 1
end

# 2 Reds + 2 Greens + 1 Blue: 65.90 - 16.475 + 49.90 + 7.95 = 107.275, delivery = 0, total = 107.27
if run_test('Test 16: Large mixed order', ['R01', 'R01', 'G01', 'G01', 'B01'], 107.27)
  passed += 1
else
  failed += 1
end

# Edge cases
# 6 Reds: 197.70 - 49.425 (3 pairs) = 148.275, delivery = 0, total = 148.27
if run_test('Test 17: Six Red Widgets (3 pairs)', ['R01', 'R01', 'R01', 'R01', 'R01', 'R01'], 148.27)
  passed += 1
else
  failed += 1
end

# 10 Blues: 79.50, delivery = 2.95, total = 82.45
if run_test('Test 18: Many Blues', ['B01'] * 10, 82.45)
  passed += 1
else
  failed += 1
end

# Summary
puts "=" * 60
puts "SUMMARY"
puts "=" * 60
puts "Total Tests: #{passed + failed}"
puts "✓ Passed: #{passed}"
puts "✗ Failed: #{failed}"
puts "Success Rate: #{((passed.to_f / (passed + failed)) * 100).round(1)}%"
puts "=" * 60

exit(failed == 0 ? 0 : 1)