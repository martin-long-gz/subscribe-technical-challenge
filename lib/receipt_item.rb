# frozen_string_literal: true

# Represents a single line item on a receipt
# Encapsulates the product, tax, and final price calculation
class ReceiptItem
  attr_reader :product, :tax

  def initialize(product:, tax:)
    @product = product
    @tax = tax
    freeze
  end

  # Final price including tax
  def total_price
    (product.total_shelf_price + tax).round(2)
  end

  # Formatted line for receipt output
  def to_s
    format('%d %s: %.2f', product.quantity, product.name, total_price)
  end
end

