# HedwigWunderground

A port of the hubot wunderground responder to Elixir/Hedwig

## Installation

If [available in Hex](https://hex.pm/packages/hedwig_wunderground), the package can be installed as:

  * Add `hedwig_wunderground` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:hedwig_wunderground, "~> 0.1.0"}]
    end
    ```


## Usage

Enable the responders by adding it to your Hedwig.Robot's config section of `config/config.exs`

```elixir
config :my_hedwig_robot, MyHedwigRobot.Robot,
  adapter: Hedwig.Adapters.Console,
  responders: [
    {HedwigWunderground.Responder, []},    
    # ...
  ]
```

You'll also need to get an API token from https://api.wunderground.com/weather/api/ and add it to your configuration.

```elixir
 config :hedwig_wunderground, :wunderground_access_token, <YOUR_TOKEN_HERE>
 ```


## Contributing

1. [Fork it!](http://github.com/labzero/hedwig_wunderground/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2016 Lab Zero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


