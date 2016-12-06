defmodule HedwigWunderground.Helper do

  alias HedwigWunderground.Formatter

  @wunderground_api Application.get_env(:hedwig_wunderground, :wunderground_api) || HedwigWunderground.HttpClient

  def weather(location), do: get(location, :forecast)
  def radar(location), do: get(location, :radar)    
  def satellite(location), do: get(location, :satellite)    
  def weathercam(location), do: get(location, :webcams)    

  defp get(location, service) do
    case @wunderground_api.get(service, location) do
      {:ok, data} -> Formatter.format(data, location)
      {:error, err} -> error(err) 
    end       
  end

  defp error(err) do
    ["Something went wrong: #{err}"]
  end
end