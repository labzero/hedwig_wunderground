defmodule HedwigWunderground.HttpClient do
  @behaviour HedwigWunderground.ApiClient
  
  @url "http://api.wunderground.com/api"
  @token Application.get_env(:hedwig_wunderground, :wunderground_access_token)
  
  def get(:weather, location), do: get_data(:forecast, location)
  def get(:forecast = service, location), do: get_data(service, location)
  def get(:radar = service, location), do: get_data(service, location)
  def get(:satellite = service, location), do: get_data(service, location)
  def get(:weathercam, location), do: get_data(:webcams, location)
  def get(:webcams = service, location), do: get_data(service, location)
  def get(service, _), do: {:error, "No such service #{service}"}

  defp get_data(service, location) do
    HedwigWunderground.Cache.get(
      key_for(service, location),
      fn -> get_remote_data(service, location) end)
  end

  defp get_remote_data(service, location) do
    case HTTPoison.get(url(service, location)) do
      {:ok, %HTTPoison.Response{status_code: status}} when status >= 400 -> 
        {:error, "HTTP status code: #{status}"}
      {:error, %HTTPoison.Error{reason: reason}} -> 
        {:error, reason}  
      {:ok, %HTTPoison.Response{body: json}} ->          
        {:ok, with_expiration(Poison.decode!(json), service, seconds)}          
    end
  end

  def with_expiration(data, service, now) do
    %{data: data, expiration: now + ttl_for(service) }
  end

  defp seconds do
    {_, secs, _} = :erlang.timestamp
    secs
  end

  defp key_for(service, location) do
    "#{Atom.to_string(service)}-#{location}"
  end

  defp ttl_for(:forecast),  do: 60 * 30
  defp ttl_for(:radar),     do: 60 * 5
  defp ttl_for(:satellite), do: 60 * 5
  defp ttl_for(:webcams),   do: 60 * 5

  defp url(service, location) do
    "#{@url}/#{@token}/#{Atom.to_string(service)}/q/#{URI.encode(location)}.json"
  end

end