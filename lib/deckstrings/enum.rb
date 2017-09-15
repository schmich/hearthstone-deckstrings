module Deckstrings
  module Enum
    def self.included(base)
      base.extend ClassMethods
    end

    # @private
    module ClassMethods
      def define(symbol, value, display = nil)
        @@values ||= {}
        @@values[value] = instance = self.new(symbol, value, display)
        self.class.send :define_method, symbol do
          instance
        end
        self.send :define_method, "#{symbol}?".to_sym do
          @symbol == symbol
        end
      end

      def parse(value)
        enum = @@values[value]
        raise RangeError.new("Unknown value: #{value}.") if !enum
        enum
      end
    end

    # @private
    def initialize(symbol, value, display)
      @symbol = symbol
      @value = value
      @display = display
    end

    # @return [String] A string description of this enum instance.
    def to_s
      @display || @symbol.to_s
    end

    # @return [Symbol] The unique symbol for this enum instance.
    def symbol
      @symbol
    end

    # @return [Integer, String, Object] The parseable value for this enum instance.
    def value
      @value
    end
  end
end
