# frozen_string_literal: true

# Represents the basic sales tax rule (10% on non-exempt items)
class BasicSalesTaxRule
  RATE = 0.10

  # Returns the tax rate for a given product
  # @param product [Product] the product to evaluate
  # @return [Float] the tax rate (0.10 or 0.0)
  def rate_for(product)
    product.tax_exempt? ? 0.0 : RATE
  end
end

