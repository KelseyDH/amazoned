# Amazoned

[![Build Status](https://travis-ci.org/KelseyDH/amazoned.svg?branch=master)](https://travis-ci.org/KelseyDH/amazoned)

[![Coverage Status](https://coveralls.io/repos/github/KelseyDH/amazoned/badge.svg?branch=master)](https://coveralls.io/github/KelseyDH/amazoned?branch=master)

Amazoned is a ruby HTTP scraper for retrieving product best seller and category rankings from Amazon.  Designed for those who don't have the time to register for Amazon's official product API.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'amazoned'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazoned

This gem supports Ruby versions 2.4 or higher.

## Usage

Use Amazoned to scrape data about a product using the ASIN of the Amazon product.  E.g. for product with an ASIN of B078SX6STW:

```ruby
    Amazoned::Client.new("B078SX6STW").call
```

will return back a Ruby hash of:

```ruby
    {
        :best_sellers_rank=>[
          {:rank=>45,
           :ladder=>"Baby > Baby Care > Pacifiers, Teethers & Teething Relief > Teethers"}
        ],
        :rank=>1602,
        :category=>"Baby",
        :package_dimensions=>"6.8 x 6.3 x 1.9 inches"
    }
```

Amazoned will raise the error `Amazoned::ProductNotFoundError` if the product ASIN does not exist.

Amazoned will raise the error `Amazoned::BotDeniedAccessError`  if the scraper is unable to get past a CAPTCHA wall after trying multiple times for the same ASIN.

To avoid anti-scraper detection, the bot spoofs a new User Agent every request and uses timing jitter to vary how long it sleeps in-between each request.


## Configuring Automatic Retries
The library can be configured to automatically retry requests that fail due to the scraper bot hitting a CAPTCHA page:

```ruby
    Amazoned.max_network_retries = 2
```

By default, `max_network_retries` is set to `3`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/amazoned.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
