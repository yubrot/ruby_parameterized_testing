# frozen_string_literal: true

require "test_helper"

describe ParameterizedTesting::Minitest::Spec do
  it "has the same version number with parameterized_testing" do
    _(ParameterizedTesting::Minitest::Spec::VERSION).must_equal ParameterizedTesting::VERSION
  end
end
