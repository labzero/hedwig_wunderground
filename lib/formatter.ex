defmodule HedwigWunderground.Formatter do

  @use_metric Application.get_env(:hedwig_wunderground, :wunderground_use_metric) || false

  def format(%{"results" => results}, _, _) when length(results) > 1 do
    "Multiple results for this location. Be more specific"
  end

  def format(%{"forecast" => %{"txt_forecast" => %{"forecastday" => [%{"title" => title, "fcttext" => imperial, "fcttext_metric" => metric}|_]}}}, location, timestamp) do
    text = if @use_metric do
      metric
    else
      imperial
    end
    "#{title} in #{location}: #{text}#{format_timestamp(timestamp)}"
  end

  def format(%{"radar" => %{"image_url" => url}}, _location, timestamp) do
    "#{url}.png#{format_timestamp(timestamp)}"
  end

  def format(%{"satellite" => %{"image_url" => url}}, _location, timestamp) do
    "#{url}.png#{format_timestamp(timestamp)}"
  end

  def format(%{"webcams" => webcams}, _location, _timestamp) do
    case webcams do
      [] -> ["no webcams near location"]
      cams ->
        %{"handle" => handle, "city" => city, "state" => state, "CURRENTIMAGEURL" => url} = Enum.random(cams)
        "#{handle} in #{city}, #{state} \n#{url}#.png\#{format_timestamp(timestamp)}"
    end
  end

  defp format_timestamp(timestamp) do
    case DateTime.from_unix(timestamp) do
      {:ok, datetime} -> "\n_#{DateTime.to_string(datetime)}_"
      _ ->
        IO.puts("invalid timestamp #{timestamp}")
        ""
    end

  end

  def format(_, _) do
    "You probably need to provide a more specific location"
  end
end