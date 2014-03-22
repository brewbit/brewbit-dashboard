# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_brewbit_dashboard'
  s.version     = '2.2.0'
  s.summary     = 'BrewBit Model-T dashboard'
  s.description = 'The BrewBit dashboard allows for remote control and monitoring of the BrewBit Model-T'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Nick Hebner'
  s.email     = 'nick@brewbit.com'
  s.homepage  = 'http://brewbit.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2.0'
  s.add_dependency 'beefcake'
  s.add_dependency 'nested_form'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
end
