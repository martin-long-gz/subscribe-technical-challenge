# frozen_string_literal: true

require_relative '../lib/tax_calculator'
require_relative '../lib/product'
require_relative '../lib/tax_rules/basic_sales_tax_rule'
require_relative '../lib/tax_rules/import_duty_rule'

RSpec.describe TaxCalculator do
  describe '.round_to_nearest_nickel' do
    it 'rounds up to nearest 0.05' do
      expect(TaxCalculator.round_to_nearest_nickel(0.5625)).to be_within(0.001).of(0.60)
      expect(TaxCalculator.round_to_nearest_nickel(0.53)).to be_within(0.001).of(0.55)
      expect(TaxCalculator.round_to_nearest_nickel(1.47)).to be_within(0.001).of(1.50)
      expect(TaxCalculator.round_to_nearest_nickel(0.01)).to be_within(0.001).of(0.05)
    end

    it 'returns same value if already a multiple of 0.05' do
      expect(TaxCalculator.round_to_nearest_nickel(1.50)).to eq(1.50)
      expect(TaxCalculator.round_to_nearest_nickel(0.05)).to eq(0.05)
    end

    it 'handles zero' do
      expect(TaxCalculator.round_to_nearest_nickel(0)).to eq(0)
    end
  end

  describe '.calculate' do
    let(:basic_tax_rule) { BasicSalesTaxRule.new }
    let(:import_duty_rule) { ImportDutyRule.new }

    context 'with exempt product (book)' do
      let(:product) { Product.new(name: 'book', price: 12.49, quantity: 2) }

      it 'calculates no basic tax' do
        tax = TaxCalculator.calculate(product: product, rules: [basic_tax_rule])
        
        expect(tax).to eq(0.0)
      end
    end

    context 'with taxable product (music CD)' do
      let(:product) { Product.new(name: 'music CD', price: 14.99) }

      it 'calculates 10% basic tax rounded up' do
        tax = TaxCalculator.calculate(product: product, rules: [basic_tax_rule])
        
        # 14.99 * 0.10 = 1.499 -> rounds to 1.50
        expect(tax).to eq(1.50)
      end
    end

    context 'with imported taxable product (imported perfume)' do
      let(:product) { Product.new(name: 'imported bottle of perfume', price: 47.50) }

      it 'calculates both basic tax and import duty' do
        tax = TaxCalculator.calculate(
          product: product, 
          rules: [basic_tax_rule, import_duty_rule]
        )
        
        # 47.50 * 0.15 = 7.125 -> rounds to 7.15
        expect(tax).to eq(7.15)
      end
    end

    context 'with imported exempt product (imported chocolates)' do
      let(:product) { Product.new(name: 'imported box of chocolates', price: 10.00) }

      it 'calculates only import duty' do
        tax = TaxCalculator.calculate(
          product: product, 
          rules: [basic_tax_rule, import_duty_rule]
        )
        
        # 10.00 * 0.05 = 0.50
        expect(tax).to eq(0.50)
      end
    end
  end
end

