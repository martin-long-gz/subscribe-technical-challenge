# frozen_string_literal: true

# Handles tax calculation with proper rounding rules
# Thread-safe as it's stateless
class TaxCalculator
  # Rounds up to the nearest 0.05
  # Example: 0.5625 -> 0.60, 0.53 -> 0.55
  def self.round_to_nearest_nickel(amount)
    (amount / 0.05).ceil * 0.05.round(2)
  end

  # Calculates tax for a product based on provided tax rules
  # Tax is calculated per unit, then multiplied by quantity
  # @param product [Product] the product to calculate tax for
  # @param rules [Array<TaxRule>] array of tax rules to apply
  # @return [Float] the total tax amount (rounded)
  def self.calculate(product:, rules:)
    total_rate = rules.sum { |rule| rule.rate_for(product) }
    # Calculate tax per unit
    raw_tax_per_unit = product.price * total_rate
    rounded_tax_per_unit = round_to_nearest_nickel(raw_tax_per_unit)
    # Multiply by quantity
    (rounded_tax_per_unit * product.quantity).round(2)
  end
end

