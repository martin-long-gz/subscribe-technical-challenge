# frozen_string_literal: true

require_relative '../lib/product'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with name, price, and quantity' do
      product = Product.new(name: 'book', price: 12.49, quantity: 2)
      
      expect(product.name).to eq('book')
      expect(product.price).to eq(12.49)
      expect(product.quantity).to eq(2)
    end

    it 'defaults quantity to 1 if not provided' do
      product = Product.new(name: 'book', price: 12.49)
      
      expect(product.quantity).to eq(1)
    end

    it 'is frozen (immutable)' do
      product = Product.new(name: 'book', price: 12.49)
      
      expect(product).to be_frozen
    end
  end

  describe '#tax_exempt?' do
    it 'returns true for books' do
      product = Product.new(name: 'book', price: 12.49)
      
      expect(product.tax_exempt?).to be true
    end

    it 'returns true for chocolate (food)' do
      product = Product.new(name: 'chocolate bar', price: 0.85)
      
      expect(product.tax_exempt?).to be true
    end

    it 'returns true for medical products (pills)' do
      product = Product.new(name: 'packet of headache pills', price: 9.75)
      
      expect(product.tax_exempt?).to be true
    end

    it 'returns false for music CD' do
      product = Product.new(name: 'music CD', price: 14.99)
      
      expect(product.tax_exempt?).to be false
    end

    it 'returns false for perfume' do
      product = Product.new(name: 'bottle of perfume', price: 18.99)
      
      expect(product.tax_exempt?).to be false
    end
  end

  describe '#imported?' do
    it 'returns true for imported products' do
      product = Product.new(name: 'imported box of chocolates', price: 10.00)
      
      expect(product.imported?).to be true
    end

    it 'returns false for non-imported products' do
      product = Product.new(name: 'book', price: 12.49)
      
      expect(product.imported?).to be false
    end
  end

  describe '#total_shelf_price' do
    it 'returns price times quantity' do
      product = Product.new(name: 'book', price: 12.49, quantity: 2)
      
      expect(product.total_shelf_price).to eq(24.98)
    end

    it 'returns price when quantity is 1' do
      product = Product.new(name: 'book', price: 12.49)
      
      expect(product.total_shelf_price).to eq(12.49)
    end
  end
end

