# frozen_string_literal: true

RSpec.describe ParameterizedTesting::Signature do
  let(:signature) { described_class.new(:foo, :bar) }

  describe "#temporary_variable_name" do
    subject { signature.temporary_variable_name }

    it { is_expected.to eq :_input_foo_bar }
  end

  describe "#map" do
    subject { signature.map(value) }

    context "with array value" do
      let(:value) { [12, 34] }

      it "zips params with array elements" do
        expect(subject).to eq({ foo: 12, bar: 34 })
      end
    end

    context "with hash value" do
      let(:value) { { foo: 10, bar: 20 } }

      it "uses the value as is" do
        expect(subject).to eq({ foo: 10, bar: 20 })
      end
    end

    context "with invalid format values" do
      [
        12, # neither array nor hash (1)
        :foo, # neither array nor hash (2)
        [12], # insufficient number of elements
        [12, 34, 56], # excessive number of elements
        { foo: 10 }, # missing fields (1)
        { foo: 10, baz: 10 }, # missing fields (2)
        { foo: 10, bar: 10, baz: 34 }, # excess fields
      ].each do |value|
        let(:value) { value }

        it "returns nil" do
          expect(subject).to be_nil
        end
      end
    end
  end
end
