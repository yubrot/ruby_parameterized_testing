# frozen_string_literal: true

module ParameterizedTesting
  # `Signature` represents the signature that each `Input` in the parameterized test must satisfy.
  class Signature
    attr_reader :params

    # @param params [Array<Symbol>]
    def initialize(*params)
      raise ArgumentError, "parameter name must be a symbol" if params.any? { !_1.is_a?(Symbol) }
      raise ArgumentError, "parameter names must be unique" if params.uniq.size != params.size

      @params = params
    end

    # @return [Symbol]
    def temporary_variable_name
      @temporary_variable_name ||= :"_input_#{params.join("_")}"
    end

    # @param value [Object]
    # @return [Hash<Symbol, Object>, nil] Mapping of parameters and values, or `nil` if mapping fails
    def map(value)
      case value
      when Array
        return if value.size != params.size

        params.zip(value).to_h
      when Hash
        return if value.size != params.size || params.any? { !value.key?(_1) }

        value
      end
    end
  end
end
