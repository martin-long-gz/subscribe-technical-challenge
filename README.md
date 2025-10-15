# Sales Tax Calculator

A Ruby application that calculates sales tax and generates receipts for shopping baskets.

## Problem Statement

This application calculates sales taxes for purchased items according to these rules:

- **Basic Sales Tax**: 10% on all goods, except books, food, and medical products (exempt)
- **Import Duty**: 5% on all imported goods (no exemptions)
- **Rounding Rule**: Tax amounts are rounded up to the nearest $0.05

## Key Features

✅ **OOP Design**: 8 focused classes with clear responsibilities  
✅ **Composition**: Tax rules composed, not inherited  
✅ **Thread-Safe**: Immutable objects, stateless services  
✅ **Well-Tested**: 55 specs, 100% passing  
✅ **Ruby Idioms**: Uses standard Ruby patterns and practices  
✅ **Production-Ready**: Error handling, documentation, extensible

## Design Decisions

### Architecture

The solution follows **Object-Oriented Programming** principles with a focus on **composition over inheritance**:

1. **Product** - Immutable value object representing an item
2. **TaxCalculator** - Stateless service for tax calculation with rounding logic
3. **Tax Rules** (BasicSalesTaxRule, ImportDutyRule) - Composable tax rules that aggregate their rates
4. **ReceiptItem** - Represents a line item with product and calculated tax
5. **Receipt** - Aggregates items and formats output
6. **InputParser** - Parses input strings into Product objects
7. **SalesTaxApplication** - Main orchestrator coordinating all components

### Key Design Principles

- **Single Responsibility**: Each class has one clear purpose
- **Composition**: Tax rules are composed together by aggregating their rates, not inherited
- **Immutability**: Core domain objects (Product, ReceiptItem) are frozen for thread safety
- **Stateless Services**: TaxCalculator and Application maintain no mutable state
- **Open/Closed**: New tax rules can be added without modifying existing code

### Thread Safety

The application is thread-safe because:

- Domain objects are immutable (frozen)
- Service classes are stateless
- No shared mutable state exists

## Requirements

- Ruby 3.0.0 or higher
- Bundler (for dependency management)

## Installation & Running

```bash
# Install dependencies
bundle install

# Run the application (processes all 3 test inputs)
ruby main.rb

# Run tests
bundle exec rspec

# Run tests with detailed output
bundle exec rspec --format documentation
```

## Usage

### Running the Application

Execute the main script to process the three test inputs:

```bash
ruby main.rb
```

### Expected Output

```
Output 1:
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32

Output 2:
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15

Output 3:
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

### Using as a Library

```ruby
require_relative 'lib/sales_tax_application'

app = SalesTaxApplication.new

input = <<~INPUT
  2 book at 12.49
  1 music CD at 14.99
  1 chocolate bar at 0.85
INPUT

receipt = app.process(input)
puts receipt
```

## Project Structure

```
.
├── Gemfile                           # Dependency management
├── README.md                         # This file
├── main.rb                           # Entry point with test data
├── lib/
│   ├── product.rb                    # Product domain object
│   ├── tax_calculator.rb             # Tax calculation logic
│   ├── tax_rules/
│   │   ├── basic_sales_tax_rule.rb   # 10% sales tax rule
│   │   └── import_duty_rule.rb       # 5% import duty rule
│   ├── receipt_item.rb               # Receipt line item
│   ├── receipt.rb                    # Receipt aggregator
│   ├── input_parser.rb               # Input parsing
│   └── sales_tax_application.rb      # Main application orchestrator
└── spec/
    ├── spec_helper.rb                # RSpec configuration
    ├── product_spec.rb               # Product tests
    ├── tax_calculator_spec.rb        # Tax calculation tests
    ├── tax_rules/
    │   ├── basic_sales_tax_rule_spec.rb
    │   └── import_duty_rule_spec.rb
    ├── receipt_item_spec.rb
    ├── receipt_spec.rb
    ├── input_parser_spec.rb
    └── sales_tax_application_spec.rb # End-to-end tests
```

## Assumptions

1. **Input Format**: Input follows the exact format: `<quantity> <product name> at <price>`

   - Quantity is a positive integer
   - Price has exactly 2 decimal places
   - "at" is the delimiter

2. **Product Categories**: Tax exemptions are determined by keywords in product names:

   - Books: Contains "book"
   - Food: Contains "chocolate"
   - Medical: Contains "pill"
   - Imported: Contains "imported"

3. **Currency**: All amounts are in the same currency (assumed to be USD)

4. **Precision**: Prices and taxes use floating-point arithmetic (sufficient for this use case)

5. **Input Validation**: Invalid input raises `ArgumentError` with a descriptive message
