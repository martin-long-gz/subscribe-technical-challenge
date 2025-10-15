# frozen_string_literal: true

# Represents the import duty tax rule (5% on all imported items)
class ImportDutyRule
  RATE = 0.05

  # Returns the tax rate for a given product
  # @param product [Product] the product to evaluate
  # @return [Float] the tax rate (0.05 or 0.0)
  def rate_for(product)
    product.imported? ? RATE : 0.0
  end
end

