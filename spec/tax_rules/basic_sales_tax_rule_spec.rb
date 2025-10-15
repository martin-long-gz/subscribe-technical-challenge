# frozen_string_literal: true

require_relative '../../lib/tax_rules/basic_sales_tax_rule'
require_relative '../../lib/product'

RSpec.describe BasicSalesTaxRule do
  subject(:rule) { described_class.new }

  describe '#rate_for' do
    context 'with tax-exempt product' do
      it 'returns 0.0 for books' do
        product = Product.new(name: 'book', price: 12.49)
        
        expect(rule.rate_for(product)).to eq(0.0)
      end

      it 'returns 0.0 for food' do
        product = Product.new(name: 'chocolate bar', price: 0.85)
        
        expect(rule.rate_for(product)).to eq(0.0)
      end

      it 'returns 0.0 for medical products' do
        product = Product.new(name: 'packet of headache pills', price: 9.75)
        
        expect(rule.rate_for(product)).to eq(0.0)
      end
    end

    context 'with taxable product' do
      it 'returns 0.10 for music CD' do
        product = Product.new(name: 'music CD', price: 14.99)
        
        expect(rule.rate_for(product)).to eq(0.10)
      end

      it 'returns 0.10 for perfume' do
        product = Product.new(name: 'bottle of perfume', price: 18.99)
        
        expect(rule.rate_for(product)).to eq(0.10)
      end
    end
  end
end

