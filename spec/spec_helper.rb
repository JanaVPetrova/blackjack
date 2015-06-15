require 'rack/test'
require 'bundler/setup'
Bundler.require

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.order = :random
  config.profile_examples = 3
  Kernel.srand config.seed
  config.disable_monkey_patching!
  config.expose_dsl_globally = false
end
