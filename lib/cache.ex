defmodule HedwigWunderground.Cache do
  defstruct [:source, :validator]

  def init, do: %HedwigWunderground.Cache{}

  def with_data_source(cache, source) do
    %HedwigWunderground.Cache{cache | :source => source}
  end

  def with_validator(cache, validator) do
    %HedwigWunderground.Cache{cache | :validator => validator}
  end

  def get(cache, key) do
    case cache.validator.(get(key)) do
      {:ok, data} -> {:ok, data}
      :error -> put(key, cache.source.())
    end
  end

  defp get(key) do
    brain().get(lobe(), key)
  end

  defp put(key, {:ok, value} = data) do
    brain().put(lobe(), key, value)
    data
  end

  defp brain do
    HedwigBrain.brain
  end

  defp lobe do
    brain().get_lobe(:wunderground)
  end
end