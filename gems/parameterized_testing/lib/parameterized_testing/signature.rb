# frozen_string_literal: true

module ParameterizedTesting
  # {Signature} represents the signature that each {Input} in the parameterized test must satisfy.
  class Signature
    # @return [Array<Symbol>] names of the parameters
    attr_reader :params

    def initialize(*params)
      raise ArgumentError, "parameter name must be a symbol" if params.any? { !_1.is_a?(Symbol) }
      raise ArgumentError, "parameter names must be unique" if params.uniq.size != params.size

      @params = params
    end

    # @return [Symbol] a symbol for temporary variables that are unique for each signature
    def temporary_variable_name
      @temporary_variable_name ||= :"_input_#{params.join("_")}"
    end

    # Compute the mapping between parameters and values, or <code>nil</code> if map fails.
    # @param value [Object] An array with the same number of elements as the number of parameters,
    #   or a hash with each parameter name as a key. For other objects, map will fail.
    # @return [Hash{Symbol => Object}, nil]
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
