# frozen_string_literal: true

module ParameterizedTesting
  # {Input} represents a single test case for a parameterized test.
  class Input
    # @return [Integer] index of the input
    attr_reader :index
    # @return [Thread::Backtrace::Location] the location of the <code>input { ... }</code> block
    attr_reader :location
    # @return [Proc] the block to compute the value of this input
    attr_reader :initializer
    # @return [String, nil] description of the input
    attr_reader :description

    def initialize(index:, location:, initializer:, description:)
      @index = index
      @location = location
      @initializer = initializer
      @description = description
    end

    # Returns a human-readable label string.
    # @return [String]
    def label
      "#{@description || "input[#{index}]"} (at line #{location.lineno})"
    end

    # Collects all <code>input { ... }</code> in a block.
    # It is important to notice that this method collects inputs by actually <code>#instance_exec</code>uting
    # the block in a dedicated context, in order to get the line number of input.
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

      def input(description = nil, &initializer)
        index = @next_index
        @next_index += 1
        location = caller_locations(1, 1).first
        @inputs << Input.new(index:, location:, initializer:, description:)
      end

      def method_missing(_name, ...)
        # do nothing
      end

      def respond_to_missing?(_name, _include_private)
        true
      end
    end
    private_constant :Collector
  end
end
