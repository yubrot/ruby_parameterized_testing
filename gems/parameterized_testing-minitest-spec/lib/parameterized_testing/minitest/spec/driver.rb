# frozen_string_literal: true

require "minitest/spec"

module ParameterizedTesting
  module Minitest
    module Spec
      # The parameterized testing driver for minitest/spec.
      # This module is automatically extended to {Minitest::Spec}.
      module Driver
        # Entry point of the parameterized testing for minitest/spec.
        # See https://github.com/yubrot/ruby_parameterized_testing
        # @param params [Array<Symbol>] parameter names
        def parameterized(*params, &)
          signature = ::ParameterizedTesting::Signature.new(*params)

          ::ParameterizedTesting::Input.collect(&).each do |input|
            # Each input corresponds to a describe:
            describe(input.label) do
              # Declare each parameter with a let:
              signature.params.each do |param|
                let(param) { __send__(signature.temporary_variable_name).fetch(param) }
              end

              # Each parameter refers this temporary variable:
              let(signature.temporary_variable_name) do
                signature.map(instance_exec(&input.initializer)) or
                  raise ::ParameterizedTesting::Minitest::Spec::InvalidInputFormatError.new(input:, signature:)
              end

              @_parameterized_testing_ctx = true
              instance_exec(&)
            end
          end
        end

        # @!visibility private
        def input(...)
          raise ParameterizedTesting::Minitest::Spec::InvalidInputCallError unless @_parameterized_testing_ctx
        end
      end
    end
  end
end

# @!visibility private
module Minitest
  class Spec
    extend ::ParameterizedTesting::Minitest::Spec::Driver
  end
end
