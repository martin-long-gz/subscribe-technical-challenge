# frozen_string_literal: true

require_relative '../../lib/tax_rules/import_duty_rule'
require_relative '../../lib/product'

RSpec.describe ImportDutyRule do
  subject(:rule) { described_class.new }

  describe '#rate_for' do
    context 'with imported product' do
      it 'returns 0.05 for imported chocolates' do
        product = Product.new(name: 'imported box of chocolates', price: 10.00)
        
        expect(rule.rate_for(product)).to eq(0.05)
      end

      it 'returns 0.05 for imported perfume' do
        product = Product.new(name: 'imported bottle of perfume', price: 47.50)
        
        expect(rule.rate_for(product)).to eq(0.05)
      end
    end

    context 'with non-imported product' do
      it 'returns 0.0 for domestic book' do
        product = Product.new(name: 'book', price: 12.49)
        
        expect(rule.rate_for(product)).to eq(0.0)
      end

      it 'returns 0.0 for domestic perfume' do
        product = Product.new(name: 'bottle of perfume', price: 18.99)
        
        expect(rule.rate_for(product)).to eq(0.0)
      end
    end
  end
end

