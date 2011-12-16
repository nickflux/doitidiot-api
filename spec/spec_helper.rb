require 'simplecov'
SimpleCov.start 'rails'

require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/rails/mocha'
  require 'capybara/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }


  RSpec.configure do |config|
    # Remove this line if you don't want RSpec's should and should_not
    # methods or matchers
    require 'rspec/expectations'
    config.include RSpec::Matchers
    
    # only run specs tagged with focus id any are tagged
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = true

    config.before(:suite) do  
      DatabaseCleaner.strategy = :truncation  
    end

    config.include(MailerMacros)
    config.include(UserMacros)

    config.before(:all) do
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    config.before(:each) do
      Timecop.return
      FakeWeb.clean_registry
      reset_email
    end
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
  file_list = '%s/Sporkfile.rb' % Rails.root
  load file_list if File.exist? file_list
end

