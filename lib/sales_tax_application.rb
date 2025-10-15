# frozen_string_literal: true

require_relative 'product'
require_relative 'tax_calculator'
require_relative 'tax_rules/basic_sales_tax_rule'
require_relative 'tax_rules/import_duty_rule'
require_relative 'receipt'
require_relative 'receipt_item'
require_relative 'input_parser'

# Main application orchestrator
# Coordinates parsing, tax calculation, and receipt generation
# This class is thread-safe as it maintains no mutable state
class SalesTaxApplication
  # Initialize with tax rules
  def initialize
    @tax_rules = [
      BasicSalesTaxRule.new,
      ImportDutyRule.new
    ].freeze
  end

  # Process input and generate receipt
  # @param input [String] the raw input string
  # @return [Receipt] the generated receipt
  def process(input)
    products = InputParser.parse(input)
    generate_receipt(products)
  end

  private

  attr_reader :tax_rules

  # Generates a receipt from products
  def generate_receipt(products)
    products.reduce(Receipt.new) do |receipt, product|
      tax = TaxCalculator.calculate(product: product, rules: tax_rules)
      item = ReceiptItem.new(product: product, tax: tax)
      receipt.add_item(item)
    end
  end
end

