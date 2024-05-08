# frozen_string_literal: true

RSpec.describe ParameterizedTesting::Input do
  let(:example_block) do
    lambda do
      input { [12, 22] }
      input { { foo: 12, bar: 22 } }

      describe "something" do
        it "tests something" do
          expect(foo + 10).to eq(bar)
        end
      end
    end
  end

  describe ".collect" do
    subject { described_class.collect(&example_block) }

    it "collects the inputs" do
      expect(subject).to match [
        have_attributes(
          label: "input[0] at line 6",
          initializer: have_attributes(call: [12, 22]),
        ),
        have_attributes(
          label: "input[1] at line 7",
          initializer: have_attributes(call: { foo: 12, bar: 22 }),
        ),
      ]
    end
  end
end
