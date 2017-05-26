# Wego Money

This gem provides functionality for calculating exchange rates using the wego currency exchange rate API.

## Installation

Add this line to your application's Gemfile:

~~~ ruby
gem 'wego-money-bank'
~~~

And then execute:

~~~
bundle
~~~

Or do the installation by yourself by running this command:

~~~
gem install wego-money-bank
~~~

## How to use it

~~~ ruby
require 'money/bank/wego_money_bank'
wmb = Money::Bank::WegoMoneyBank.new
wmb.cache = 'path/to/cahe.json'

# (optional)
# set the seconds until the rates will be expired automatically
# if not set, then it will never expire
wmb.ttl_in_seconds = 3600

wmp.update_rates
~~~

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wego-money-bank.

