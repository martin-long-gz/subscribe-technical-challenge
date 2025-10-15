# frozen_string_literal: true

require_relative 'receipt_item'

# Represents a complete receipt with multiple items
# Handles aggregation of totals and formatting output
class Receipt
  attr_reader :items

  def initialize(items = [])
    @items = items.freeze
  end

  # Add a receipt item and return a new receipt
  def add_item(item)
    Receipt.new(items + [item])
  end

  # Total sales tax across all items
  def total_sales_tax
    items.sum(&:tax).round(2)
  end

  # Grand total (all items including tax)
  def total
    items.sum(&:total_price).round(2)
  end

  # Formatted receipt output
  def to_s
    output = items.map(&:to_s).join("\n")
    output += "\n" + format('Sales Taxes: %.2f', total_sales_tax)
    output += "\n" + format('Total: %.2f', total)
    output
  end
end

