brewbit-dashboard

Backend for managing BrewBit devices

Installation
------------

Add brewbit_dashboard to your Gemfile:

```ruby
gem 'brewbit_dashboard'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g brewbit_dashboard:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'brewbit_dashboard/factories'
```

Copyright (c) 2014 [name of extension creator], released under the New BSD License

