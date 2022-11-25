require 'codecov'
require 'simplecov'
require 'simplecov-html'
require "simplecov_json_formatter"

SimpleCov.start do
  add_filter %r{^(?!/src/).*(?!\.bash)$}
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter,
  Codecov::SimpleCov::Formatter
])
