# frozen_string_literal: true

require_relative 'product'

# Parses input strings into Product objects
# Handles the format: "quantity item_name at price"
class InputParser
  # Captures: quantity, product name, price
  INPUT_PATTERN = /^(\d+)\s+(.+?)\s+at\s+(\d+\.\d{2})$/

  # Parses a single line of input
  # @param line [String] input line to parse
  # @return [Product] the parsed product
  # @raise [ArgumentError] if input format is invalid
  def self.parse_line(line)
    match = line.strip.match(INPUT_PATTERN)
    raise ArgumentError, "Invalid input format: #{line}" unless match

    quantity = match[1].to_i
    name = match[2].strip
    price = match[3].to_f

    Product.new(name: name, price: price, quantity: quantity)
  end

  # Parses multiple lines of input
  # @param input [String] multi-line input string
  # @return [Array<Product>] array of parsed products
  def self.parse(input)
    input.strip.split("\n").reject { |line| line.strip.empty? }.map { |line| parse_line(line) }
  end
end

