# frozen_string_literal: true

require_relative '../lib/receipt_item'
require_relative '../lib/product'

RSpec.describe ReceiptItem do
  let(:product) { Product.new(name: 'music CD', price: 14.99, quantity: 1) }
  let(:tax) { 1.50 }
  subject(:item) { described_class.new(product: product, tax: tax) }

  describe '#initialize' do
    it 'creates a receipt item with product and tax' do
      expect(item.product).to eq(product)
      expect(item.tax).to eq(1.50)
    end

    it 'is frozen (immutable)' do
      expect(item).to be_frozen
    end
  end

  describe '#total_price' do
    it 'returns shelf price plus tax' do
      expect(item.total_price).to eq(16.49)
    end
  end

  describe '#to_s' do
    it 'formats as receipt line' do
      expect(item.to_s).to eq('1 music CD: 16.49')
    end

    context 'with multiple quantity' do
      let(:product) { Product.new(name: 'book', price: 12.49, quantity: 2) }
      let(:tax) { 0.0 }

      it 'includes quantity in output' do
        expect(item.to_s).to eq('2 book: 24.98')
      end
    end
  end
end

