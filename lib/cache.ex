defmodule HedwigWunderground.Cache do

  def get(key, fetcher) do
    cached = get(key)
    case valid?(get(key)) do 
      {:ok, data} -> {:ok, data} 
      :error -> put(key, fetcher.())
    end 
  end

  defp valid?(%{expiration: expiration, data: data}) do
    if expiration > seconds do
      {:ok, data}
    else
      :error
    end
  end

  defp valid?(_) do
    :error
  end

  defp get(key) do
    brain.get(cache, key)
  end

  defp put(key, {:ok, value} = data) do
    brain.put(cache, key, value)
    data
  end

  defp brain do
    HedwigBrain.brain
  end

  defp cache do
    brain.get_lobe(:wunderground)
  end

  defp seconds do
    {_, secs, _} = :erlang.timestamp
    secs
  end
    
end