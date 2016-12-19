require 'rails_helper'
RSpec.configure do |config|

  headless = Headless.new
  headless.start

  Capybara.javascript_driver = :webkit

  at_exit do
    headless.destroy
  end

  Capybara::Webkit.configure do |config|
    config.allow_url("172.16.1.10")
  end

  config.include FeatureMacros, type: :feature
  config.include WaitForAjax, type: :feature
  config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    # Sphinx Index data when running an acceptance spec.
    DatabaseCleaner.strategy = :truncation
    index
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
