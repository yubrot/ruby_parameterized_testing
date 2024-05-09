# frozen_string_literal: true

require "parameterized_testing"

require_relative "rspec/version"
require_relative "rspec/driver"

module ParameterizedTesting
  module RSpec
    # Error raised when the format of the parameterized test input is incorrect.
    class InvalidInputFormatError < Exception # rubocop:disable Lint/InheritException
      # @return [Input]
      attr_reader :input
      # @return [Signature]
      attr_reader :signature

      def initialize(message = nil, input:, signature:)
        @input = input
        @signature = signature
        super(message)
      end
    end

    # Error raised when the input block is called outside of the parameterized test.
    class InvalidInputCallError < Exception # rubocop:disable Lint/InheritException
    end
  end
end
