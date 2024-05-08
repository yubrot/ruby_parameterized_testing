# frozen_string_literal: true

module ParameterizedTesting
  # `Input` represents a single test case for a parameterized test.
  class Input
    attr_reader :index, :location, :initializer

    # @param index [Integer]
    # @param location [Thread::Backtrace::Location]
    # @param initializer [Proc]
    def initialize(index:, location:, initializer:)
      @index = index
      @location = location
      @initializer = initializer
    end

    # Gets a human-readable label string.
    # @return [String]
    def label
      "input[#{index}] at line #{location.lineno}"
    end

    # Collects all `input { ... }` in a block.
    # It is important to notice that `#parameterized` collects inputs by actually `instance_exec`uting
    # the block in a dedicated context in order to get the line number of input.
    # In this context, all other method calls are ignored.
    # @return [Array<Input>]
    def self.collect(&)
      inputs = []
      Collector.new(inputs).instance_exec(&)
      inputs
    end

    class Collector # :nodoc:
      def initialize(inputs)
        @inputs = inputs
        @next_index = 0
      end

      def input(&initializer)
        index = @next_index
        @next_index += 1
        location = caller_locations(1, 1).first
        @inputs << Input.new(index:, location:, initializer:)
      end

      def method_missing(_name, ...)
        # do nothing
      end

      def respond_to_missing?(_name, _include_private)
        true
      end
    end
  end
end
