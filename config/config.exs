# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :hedwig_wunderground, :wunderground_api,HedwigWunderground.HttpClient

import_config "#{Mix.env}.exs"
