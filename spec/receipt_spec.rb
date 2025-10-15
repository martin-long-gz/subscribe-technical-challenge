# frozen_string_literal: true

require_relative '../lib/receipt'
require_relative '../lib/receipt_item'
require_relative '../lib/product'

RSpec.describe Receipt do
  describe '#initialize' do
    it 'creates an empty receipt' do
      receipt = Receipt.new
      
      expect(receipt.items).to be_empty
    end

    it 'creates a receipt with items' do
      product = Product.new(name: 'book', price: 12.49)
      item = ReceiptItem.new(product: product, tax: 0.0)
      receipt = Receipt.new([item])
      
      expect(receipt.items).to contain_exactly(item)
    end
  end

  describe '#add_item' do
    it 'returns a new receipt with the added item' do
      receipt1 = Receipt.new
      product = Product.new(name: 'book', price: 12.49)
      item = ReceiptItem.new(product: product, tax: 0.0)
      
      receipt2 = receipt1.add_item(item)
      
      expect(receipt1.items).to be_empty
      expect(receipt2.items).to contain_exactly(item)
    end
  end

  describe '#total_sales_tax' do
    it 'sums tax across all items' do
      product1 = Product.new(name: 'music CD', price: 14.99)
      product2 = Product.new(name: 'book', price: 12.49, quantity: 2)
      
      item1 = ReceiptItem.new(product: product1, tax: 1.50)
      item2 = ReceiptItem.new(product: product2, tax: 0.0)
      
      receipt = Receipt.new([item1, item2])
      
      expect(receipt.total_sales_tax).to eq(1.50)
    end
  end

  describe '#total' do
    it 'sums total price across all items' do
      product1 = Product.new(name: 'book', price: 12.49, quantity: 2)
      product2 = Product.new(name: 'music CD', price: 14.99)
      product3 = Product.new(name: 'chocolate bar', price: 0.85)
      
      item1 = ReceiptItem.new(product: product1, tax: 0.0)
      item2 = ReceiptItem.new(product: product2, tax: 1.50)
      item3 = ReceiptItem.new(product: product3, tax: 0.0)
      
      receipt = Receipt.new([item1, item2, item3])
      
      expect(receipt.total).to eq(42.32)
    end
  end

  describe '#to_s' do
    it 'formats complete receipt' do
      product1 = Product.new(name: 'book', price: 12.49, quantity: 2)
      product2 = Product.new(name: 'music CD', price: 14.99)
      product3 = Product.new(name: 'chocolate bar', price: 0.85)
      
      item1 = ReceiptItem.new(product: product1, tax: 0.0)
      item2 = ReceiptItem.new(product: product2, tax: 1.50)
      item3 = ReceiptItem.new(product: product3, tax: 0.0)
      
      receipt = Receipt.new([item1, item2, item3])
      
      expected = "2 book: 24.98\n1 music CD: 16.49\n1 chocolate bar: 0.85\nSales Taxes: 1.50\nTotal: 42.32"
      expect(receipt.to_s).to eq(expected)
    end
  end
end

