defmodule HedwigWunderground.HttpClient do
  @behaviour HedwigWunderground.ApiClient
  
  alias HedwigWunderground.Cache

  @url "http://api.wunderground.com/api"
  @token Application.get_env(:hedwig_wunderground, :wunderground_access_token)
  
  def get(:weather, location), do: get_data(:forecast, location)
  def get(:forecast = service, location), do: get_data(service, location)
  def get(:radar = service, location), do: get_data(service, location)
  def get(:satellite = service, location), do: get_data(service, location)
  def get(:weathercam, location), do: get_data(:webcams, location)
  def get(:webcams = service, location), do: get_data(service, location)
  def get(service, _), do: {:error, "No such service #{service}"}

  def valid?(%{created_at: created_at, data: data, service: service} = result) do
    if expired?(service, created_at) do
      :error         
    else
      {:ok, result}
    end
  end

  def valid?(_) do
    :error
  end

  defp get_data(service, location) do
    service
    |> cache(location)
    |> Cache.get(key_for(service, location))
  end

  defp get_remote_data(service, location) do
    case HTTPoison.get(url(service, location)) do
      {:ok, %HTTPoison.Response{status_code: status}} when status >= 400 -> 
        {:error, "HTTP status code: #{status}"}
      {:error, %HTTPoison.Error{reason: reason}} -> 
        {:error, reason}  
      {:ok, %HTTPoison.Response{body: json}} ->          
        {:ok, with_metadata(Poison.decode!(json), service, seconds)}          
    end
  end

  defp with_metadata(data, service, now) do
    %{data: data, created_at: now, service: service}
  end

  defp seconds do
    :os.system_time(:seconds)
  end

  defp cache(service, location) do
    Cache.init
    |> Cache.with_data_source(fn -> get_remote_data(service, location) end)
    |> Cache.with_validator(&HedwigWunderground.HttpClient.valid?/1)
  end

  defp key_for(service, location) do
    "#{Atom.to_string(service)}-#{String.upcase(location)}"
  end

  defp expired?(service, created_at) do
    seconds > (created_at + ttl_for(service))  
  end

  # created + ttl is the expiration time. If now is > than expiration time, it's expired

  #created 1481573333 ttl 300 now 1481573339 - expired: true


  defp ttl_for(:forecast),  do: 60 * 30
  defp ttl_for(:radar),     do: 60 * 5
  defp ttl_for(:satellite), do: 60 * 5
  defp ttl_for(:webcams),   do: 60 * 5

  defp url(service, location) do
    "#{@url}/#{@token}/#{Atom.to_string(service)}/q/#{URI.encode(location)}.json"
  end

end