#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/sales_tax_application'

INPUT_1 = <<~INPUT
  2 book at 12.49
  1 music CD at 14.99
  1 chocolate bar at 0.85
INPUT

INPUT_2 = <<~INPUT
  1 imported box of chocolates at 10.00
  1 imported bottle of perfume at 47.50
INPUT

INPUT_3 = <<~INPUT
  1 imported bottle of perfume at 27.99
  1 bottle of perfume at 18.99
  1 packet of headache pills at 9.75
  3 imported boxes of chocolates at 11.25
INPUT

app = SalesTaxApplication.new

puts "Output 1:"
puts app.process(INPUT_1)
puts "\nOutput 2:"
puts app.process(INPUT_2)
puts "\nOutput 3:"
puts app.process(INPUT_3)

