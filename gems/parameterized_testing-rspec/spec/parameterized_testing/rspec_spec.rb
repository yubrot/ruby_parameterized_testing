# frozen_string_literal: true

RSpec.describe ParameterizedTesting::RSpec do
  it "has the same version number with parameterized_testing" do
    expect(ParameterizedTesting::RSpec::VERSION).to eq ParameterizedTesting::VERSION
  end
end
