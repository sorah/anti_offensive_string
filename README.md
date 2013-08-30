# AntiOffensiveString

Respond error for requests include some offensive string, that may crash browsers

http://techcrunch.com/2013/08/29/bug-in-apples-coretext-allows-specific-string-of-characters-to-crash-ios-6-os-x-10-8-apps/

## Installation

Add this line to your application's Gemfile:

    gem 'anti_offensive_string'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anti_offensive_string

## Usage

### Rails

``` ruby
# config/application.rb

config.middleware.insert(0, AntiOffensiveString)
```

### Other

``` ruby
# config.ru

use AntiOffensiveString
run ...
```

## Customize error response

``` ruby
# respond with fixed value
AntiOffensiveString.error_response = [400, {'Content-Type' => "text/html"}, ['<h1>Error</h1>']]

# respond with block
AntiOffensiveString.on_offensive_request do |env|
  p env # => rack env
  [400, {'Content-Type' => "text/html"}, ['<h1>Error</h1>']]
end
```

See also: http://rack.rubyforge.org/doc/SPEC.html

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
