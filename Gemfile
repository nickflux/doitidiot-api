source 'http://rubygems.org'

gem 'thin'
gem 'rails', '3.1.3'
gem 'mongoid', '~> 2.3'
gem 'bson_ext', '~> 1.4'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'yajl-ruby' # for parsing JSON files
gem 'rack-offline' # for offline mobile app

gem 'devise' # authentication etc
gem 'RedCloth' # Textile
gem 'haml' # templates
gem 'has_scope' # Aides search queries
gem 'inherited_resources' # For minimal controllers
gem 'geocoder' # for IP/location based functions

gem 'therubyracer' # JavaScript runtime
gem 'mustache' # logic-less templates for Ruby and JavaScript

gem 'log_buddy' # for improved logging

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test, :development do
  gem 'rspec-core', :git => "git://github.com/rspec/rspec-core.git"
  gem 'rspec-rails', '2.8.1'
  gem 'email_spec'
  gem 'rspec-rails-mocha', '~> 0.3.1', :require => false
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'fakeweb'
  gem 'vcr', '2.0.0.rc1'
  #gem 'rb-fsevent'#, :require => false if RUBY_PLATFORM =~ /darwin/i
  #gem 'growl_notify'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-pow'
  gem 'spork', '> 0.9.0.rc'
  gem 'guard-spork'
  gem 'pry'
  gem 'mailcatcher'
  gem 'simplecov', :require => false
end