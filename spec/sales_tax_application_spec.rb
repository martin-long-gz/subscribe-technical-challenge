# frozen_string_literal: true

require_relative '../lib/sales_tax_application'

RSpec.describe SalesTaxApplication do
  subject(:app) { described_class.new }

  describe '#process' do
    context 'with Input 1' do
      let(:input) do
        <<~INPUT
          2 book at 12.49
          1 music CD at 14.99
          1 chocolate bar at 0.85
        INPUT
      end

      let(:expected_output) do
        "2 book: 24.98\n1 music CD: 16.49\n1 chocolate bar: 0.85\nSales Taxes: 1.50\nTotal: 42.32"
      end

      it 'generates correct receipt' do
        receipt = app.process(input)
        
        expect(receipt.to_s).to eq(expected_output)
      end

      it 'calculates correct sales tax' do
        receipt = app.process(input)
        
        expect(receipt.total_sales_tax).to eq(1.50)
      end

      it 'calculates correct total' do
        receipt = app.process(input)
        
        expect(receipt.total).to eq(42.32)
      end
    end

    context 'with Input 2' do
      let(:input) do
        <<~INPUT
          1 imported box of chocolates at 10.00
          1 imported bottle of perfume at 47.50
        INPUT
      end

      let(:expected_output) do
        "1 imported box of chocolates: 10.50\n1 imported bottle of perfume: 54.65\nSales Taxes: 7.65\nTotal: 65.15"
      end

      it 'generates correct receipt' do
        receipt = app.process(input)
        
        expect(receipt.to_s).to eq(expected_output)
      end

      it 'calculates correct sales tax' do
        receipt = app.process(input)
        
        expect(receipt.total_sales_tax).to eq(7.65)
      end

      it 'calculates correct total' do
        receipt = app.process(input)
        
        expect(receipt.total).to eq(65.15)
      end
    end

    context 'with Input 3' do
      let(:input) do
        <<~INPUT
          1 imported bottle of perfume at 27.99
          1 bottle of perfume at 18.99
          1 packet of headache pills at 9.75
          3 imported boxes of chocolates at 11.25
        INPUT
      end

      let(:expected_output) do
        "1 imported bottle of perfume: 32.19\n1 bottle of perfume: 20.89\n1 packet of headache pills: 9.75\n3 imported boxes of chocolates: 35.55\nSales Taxes: 7.90\nTotal: 98.38"
      end

      it 'generates correct receipt' do
        receipt = app.process(input)
        
        expect(receipt.to_s).to eq(expected_output)
      end

      it 'calculates correct sales tax' do
        receipt = app.process(input)
        
        expect(receipt.total_sales_tax).to eq(7.90)
      end

      it 'calculates correct total' do
        receipt = app.process(input)
        
        expect(receipt.total).to eq(98.38)
      end
    end
  end
end

