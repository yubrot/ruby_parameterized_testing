# frozen_string_literal: true

RSpec.describe ParameterizedTesting::RSpec::Driver do
  describe "#parameterized" do
    context "with orphan input" do
      subject do
        RSpec.describe "something" do
          input { [1, 2] }

          it { is_expected.to be_truthy }
        end
      end

      it "raises an InvalidInputCallError" do
        expect { subject }.to raise_error(ParameterizedTesting::RSpec::InvalidInputCallError)
      end
    end

    context "with no input" do
      subject do
        RSpec.describe "something" do
          parameterized(:foo, :bar) do
            it "always fails, if executed" do
              expect(true).to be false # rubocop:disable RSpec/ExpectActual
            end
          end
        end
      end

      it "runs no test" do
        expect { subject }.not_to raise_error
      end
    end

    context "with invalid input" do
      parameterized(:foo, :bar) do
        input { [12, 34, 56] }

        it "raises an InvalidInputFormatError" do
          expect { foo }.to raise_error(ParameterizedTesting::RSpec::InvalidInputFormatError)
        end
      end
    end

    context "with multiple inputs" do
      parameterized(:a, :b, :c) do
        input { %w[foo bar foobar] }
        input { %w[hoge fuga hogefuga] }
        input { { a: 123, b: 456, c: 579 } }

        subject { a + b }

        it "tests for each input" do
          expect(subject).to eq c
        end
      end
    end

    context "with nested parameterized" do
      parameterized(:op, :result) do
        input { [->(x, y) { x + y }, a + b] }
        input { [->(x, y) { x * y }, a * b] }

        subject { op.call(a, b) }

        parameterized(:a, :b) do
          input { [2, 3] }
          input { [5, 7] }

          it "tests for each input combination" do
            expect(subject).to eq result
          end
        end
      end
    end
  end
end
