# frozen_string_literal: true

require "test_helper"

describe ParameterizedTesting::Minitest::Spec::Driver do
  describe "#parameterized" do
    # TODO: How to test this (maybe we should avoid using minitest/autorun)
    # describe "with orphan input" do
    #   input { [1, 2] }
    # end

    describe "with no input" do
      parameterized(:foo, :bar) do
        it "always fails, if executed" do
          _(true).must_equal false
        end
      end
    end

    describe "with invalid input" do
      parameterized(:foo, :bar) do
        input { [12, 34, 56] }

        it "raises an InvalidInputFormatError" do
          _ { foo }.must_raise ParameterizedTesting::Minitest::Spec::InvalidInputFormatError
        end
      end
    end

    describe "with multiple inputs" do
      parameterized(:a, :b, :c) do
        input { %w[foo bar foobar] }
        input { %w[hoge fuga hogefuga] }
        input { { a: 123, b: 456, c: 579 } }

        subject { a + b }

        it "tests for each input" do
          _(subject).must_equal c
        end
      end
    end

    describe "with nested parameterized" do
      parameterized(:op, :result) do
        input { [->(x, y) { x + y }, a + b] }
        input { [->(x, y) { x * y }, a * b] }

        subject { op.call(a, b) }

        parameterized(:a, :b) do
          input { [2, 3] }
          input { [5, 7] }

          it "tests for each input combination" do
            _(subject).must_equal result
          end
        end
      end
    end
  end
end
