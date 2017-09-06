module Enum
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def define(symbol, value, display = nil)
      @@values ||= {}
      @@values[value] = instance = self.new(symbol, value, display)
      self.class.send :define_method, symbol do
        instance
      end
    end

    def parse(value)
      enum = @@values[value]
      raise RangeError.new("Unknown value: #{value}.") if !enum
      enum
    end
  end

  def initialize(symbol, value, display)
    @symbol = symbol
    @value = value
    @display = display
  end

  def to_s
    @display || @symbol.to_s
  end

  def symbol
    @symbol
  end

  def value
    @value
  end
end
