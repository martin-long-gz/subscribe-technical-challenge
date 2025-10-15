# frozen_string_literal: true

require_relative '../lib/input_parser'

RSpec.describe InputParser do
  describe '.parse_line' do
    it 'parses a single line with quantity 1' do
      product = InputParser.parse_line('1 music CD at 14.99')
      
      expect(product.quantity).to eq(1)
      expect(product.name).to eq('music CD')
      expect(product.price).to eq(14.99)
    end

    it 'parses a line with quantity greater than 1' do
      product = InputParser.parse_line('2 book at 12.49')
      
      expect(product.quantity).to eq(2)
      expect(product.name).to eq('book')
      expect(product.price).to eq(12.49)
    end

    it 'parses a line with multi-word product name' do
      product = InputParser.parse_line('1 imported box of chocolates at 10.00')
      
      expect(product.quantity).to eq(1)
      expect(product.name).to eq('imported box of chocolates')
      expect(product.price).to eq(10.00)
    end

    it 'handles extra whitespace' do
      product = InputParser.parse_line('  1 book at 12.49  ')
      
      expect(product.name).to eq('book')
    end

    it 'raises error for invalid format' do
      expect { InputParser.parse_line('invalid input') }
        .to raise_error(ArgumentError, /Invalid input format/)
    end
  end

  describe '.parse' do
    it 'parses multiple lines' do
      input = <<~INPUT
        2 book at 12.49
        1 music CD at 14.99
        1 chocolate bar at 0.85
      INPUT

      products = InputParser.parse(input)
      
      expect(products.length).to eq(3)
      expect(products[0].name).to eq('book')
      expect(products[1].name).to eq('music CD')
      expect(products[2].name).to eq('chocolate bar')
    end

    it 'filters out empty lines' do
      input = "1 book at 12.49\n\n2 music CD at 14.99"
      
      products = InputParser.parse(input)
      
      expect(products.length).to eq(2)
      expect(products[0].name).to eq('book')
      expect(products[1].name).to eq('music CD')
    end
  end
end

