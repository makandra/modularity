require 'modularity'

RSpec.configure do |config|
  config.expect_with(:rspec) { |expects| expects.syntax = :should }
  config.mock_with(:rspec) { |mocks| mocks.syntax = [:should, :receive] }
end
