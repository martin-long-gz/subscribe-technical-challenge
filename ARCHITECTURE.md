# Architecture Overview

## Design Philosophy

- Object-Oriented Design (OOD)
- SOLID principles
- Composition over Inheritance
- Thread-safety
- Testability

## Class Responsibilities

### Domain Layer

#### `Product`

- **Responsibility**: Represents an immutable product with quantity, name, and price
- **Pattern**: Value Object
- **Thread-Safety**: Frozen after creation
- **Key Methods**:
  - `tax_exempt?` - Determines if product is exempt from basic sales tax
  - `imported?` - Determines if product is imported
  - `total_shelf_price` - Calculates price × quantity

#### `ReceiptItem`

- **Responsibility**: Represents a line item on a receipt (product + tax)
- **Pattern**: Value Object
- **Thread-Safety**: Frozen after creation
- **Key Methods**:
  - `total_price` - Returns final price including tax
  - `to_s` - Formats as receipt line

#### `Receipt`

- **Responsibility**: Aggregates receipt items and calculates totals
- **Pattern**: Aggregate Root
- **Thread-Safety**: Immutable collection of items
- **Key Methods**:
  - `add_item` - Returns new receipt with added item (immutable)
  - `total_sales_tax` - Sum of all taxes
  - `total` - Grand total
  - `to_s` - Formatted receipt output

### Service Layer

#### `TaxCalculator`

- **Responsibility**: Calculates tax with proper rounding
- **Thread-Safety**: No mutable state, class methods only
- **Key Methods**:
  - `round_to_nearest_nickel` - Rounds up to nearest 0.05
  - `calculate` - Calculates total tax for a product

### Tax Rules (Rate Aggregation)

#### `BasicSalesTaxRule`

- **Responsibility**: Implements 10% sales tax rule
- **Thread-Safety**: Stateless
- **Key Methods**:
  - `rate_for(product)` - Returns 0.10 or 0.0 based on exemptions

#### `ImportDutyRule`

- **Responsibility**: Implements 5% import duty rule
- **Thread-Safety**: Stateless
- **Key Methods**:
  - `rate_for(product)` - Returns 0.05 for imported, 0.0 otherwise

### Infrastructure Layer

#### `InputParser`

- **Responsibility**: Parses input strings into Product objects
- **Thread-Safety**: Stateless
- **Key Methods**:
  - `parse_line` - Parses single input line
  - `parse` - Parses multi-line input

### Application Layer

#### `SalesTaxApplication`

- **Responsibility**: Orchestrates the entire process
- **Thread-Safety**: No mutable state
- **Key Methods**:
  - `process` - Processes input and returns receipt

## Design Patterns Used

1. **Value Object** - Product, ReceiptItem (immutable domain objects)
2. **Aggregate Root** - Receipt aggregates ReceiptItems

## Architectural Concepts

- **Rate Aggregation** - Tax rules contribute rates that are summed together (not Strategy pattern)
- **Immutable Chaining** - Receipt uses `add_item` to return new instances
- **Application Service** - SalesTaxApplication orchestrates the workflow
- **Stateless Services** - TaxCalculator and InputParser maintain no state

## Why Composition Over Inheritance?

Instead of creating a hierarchy like:

```ruby
class TaxRule
  class BasicSalesTaxRule < TaxRule
  class ImportDutyRule < TaxRule
```

We use composition:

```ruby
class SalesTaxApplication
  def initialize
    @tax_rules = [
      BasicSalesTaxRule.new,
      ImportDutyRule.new
    ]
  end
```

**Benefits**:

- Easy to add new rules without modifying existing code (Open/Closed Principle)
- Rules can be combined dynamically
- No fragile inheritance hierarchies
- Better testability

## Thread-Safety Guarantees

1. **Immutable Domain Objects**: Product and ReceiptItem are frozen
2. **Stateless Services**: TaxCalculator, InputParser have no state
3. **No Shared Mutable State**: Application maintains no instance variables
4. **Functional Approach**: Receipt.add_item returns new receipt (no mutation)

## Extensibility

### Adding a New Tax Rule

```ruby
class LuxuryTaxRule
  RATE = 0.20

  def rate_for(product)
    product.name.downcase.include?('luxury') ? RATE : 0.0
  end
end

# Add to application
def initialize
  @tax_rules = [
    BasicSalesTaxRule.new,
    ImportDutyRule.new,
    LuxuryTaxRule.new  # New rule
  ].freeze
end
```

### Adding a New Product Category

Simply add the new keyword to the exemption list in `Product#tax_exempt?`:

```ruby
# In lib/product.rb - just add to the array
def tax_exempt?
  exempt_keywords = ['book', 'chocolate', 'pill', 'vegetables']  # Add new keyword here
  exempt_keywords.any? { |keyword| name.downcase.include?(keyword) }
end
```

This approach uses keyword matching, so any product with "vegetables" in the name becomes exempt. For more complex categorization, we could refactor to use a proper Category enum or classification system.

## Testing Strategy

1. **Unit Tests** - Each class tested in isolation
2. **Integration Tests** - End-to-end tests with real inputs
3. **Edge Cases** - Rounding, zero values, multiple quantities
4. **Thread-Safety** - Verify immutability with `be_frozen`

## Ruby Idioms Used

✅ `freeze` for immutability
✅ `attr_reader` for accessors
✅ `reduce` for aggregation
✅ Duck typing for tax rules
✅ Regular expressions for parsing
✅ `format` for output formatting
✅ Blocks and Enumerable methods
✅ `frozen_string_literal: true`

## Production Readiness Checklist

✅ Thread-safe design
✅ Error handling (ArgumentError for invalid input)
✅ Comprehensive test coverage
✅ Documentation (README, ARCHITECTURE)
✅ Proper separation of concerns
✅ SOLID principles
✅ Ruby best practices
✅ No external dependencies (except RSpec for testing)
✅ Clear project structure
✅ Extensible architecture
