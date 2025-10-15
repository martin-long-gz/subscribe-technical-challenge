# frozen_string_literal: true

# Represents a product with its core attributes
# This class is immutable to ensure thread-safety
class Product
  attr_reader :name, :price, :quantity

  def initialize(name:, price:, quantity: 1)
    @name = name.freeze
    @price = price
    @quantity = quantity
    freeze
  end

  # Checks if product is exempt from basic sales tax
  # Exempt categories: books, food, medical products
  def tax_exempt?
    exempt_keywords = ['book', 'chocolate', 'pill']
    exempt_keywords.any? { |keyword| name.downcase.include?(keyword) }
  end

  # Checks if product is imported
  def imported?
    name.downcase.include?('imported')
  end

  # Total shelf price (price × quantity)
  def total_shelf_price
    price * quantity
  end
end

