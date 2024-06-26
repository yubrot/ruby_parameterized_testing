# frozen_string_literal: true

require_relative "lib/parameterized_testing/version"

Gem::Specification.new do |spec|
  spec.name = "parameterized_testing"
  spec.version = ParameterizedTesting::VERSION
  spec.authors = ["yubrot"]
  spec.email = ["yubrot@gmail.com"]

  spec.summary = "Parameterized testing utility"
  spec.description = "Parameterized testing utility"
  spec.homepage = "https://github.com/yubrot/ruby_parameterized_testing"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ spec/ Gemfile Rakefile .rspec .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
