# ruby_parameterized_testing

Parameterized testing utility for Ruby.

## Installation

Add `parameterized_testing-rspec` as a dependency if you are using RSpec.

```ruby
group :test do
  gem "parameterized_testing-rspec", "~> 0.1"
end
```

## Usage (with RSpec)

With this gem, parameterized tests can be written as follows:

```ruby
# parameterized_testing-rspec example
RSpec.describe "something" do
  # #parameterized is available in the context of RSpec ExampleGroup.
  parameterized(:a, :b, :result) do
    # Declare the concrete input corresponding to the parameters with #input.
    input { [1, 2, 3] }                  # shorthand syntax
    input { { a: 4, b: 5, result: 9 } }  # verbose syntax
    input { ["foo", "bar", "foobar"] }
    ...

    # Other than that, we can write tests in the same way as a conventional RSpec ExampleGroup.
    subject { a + b }

    it { is_expected.to eq result }
  end
end
```

### How `#parameterized` works

It is important to notice that `#parameterized` collects inputs by actually `instance_exec`uting
the block in a dedicated context in order to embed the line number of input to `#context`. In this context, all other method calls are ignored.

If you want to perform some extra procedure in the context of RSpec ExampleGroup, place them outside of `#parameterized`.

### Differences with `rspec-parameterized`

There is already a gem called [`rspec-parameterized`](https://github.com/tomykaira/rspec-parameterized) that supports parameterized testing.

`parameterized_testing` does not depend on `parser`, `proc_to_ast`, or `unparser`.
Code like the example above is conceptually[^1] expanded as follows:

```ruby
RSpec.describe "something" do
  sig_a_b_result = ::ParameterizedTesting::Signature.new(:a, :b, :result)

  context 'input[0] at line 6' do
    let(:_input_a_b_result) { sig_a_b_result.map([1, 2, 3]) }
    let(:a) { __send__(:_input_a_b_result).fetch(:a) }
    let(:b) { __send__(:_input_a_b_result).fetch(:b) }
    let(:result) { __send__(:_input_a_b_result).fetch(:result) }

    subject { a + b }

    it { is_expected.to eq result }
  end

  context 'input[1] at line 7' do
    let(:_input_a_b_result) { sig_a_b_result.map({ a: 4, b: 5, result: 9 }) }
    ...
  end

  context 'input[2] at line 8' do
    let(:_input_a_b_result) { sig_a_b_result.map(["foo", "bar", "foobar"]) }
    ...
  end

  ...
end
```

Since each `input` is declared as a block, there are no helpers such as `ref` or `lazy`, which were in `rspec-parameterized`.

[^1]: The real implementation can be seen in [driver.rb](https://github.com/yubrot/ruby_parameterized_testing/blob/main/gems/parameterized_testing-rspec/lib/parameterized_testing/rspec/driver.rb), for example.

## Usage (with minitest)

TODO: add support

## Development

```
$ git clone https://github.com/yubrot/ruby_parameterized_testing
$ cd gems/parameterized_testing
$ bin/setup
$ bundle exec rake --tasks
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yubrot/ruby_parameterized_testing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](./CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
