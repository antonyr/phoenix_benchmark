defmodule Detectors do
  use HTTPoison.Base

  def process_url(url) do
    Dotenv.get("API_SERVER") <> "/" <> url
  end

  def process_response_body(body) do
    responseTime = Poison.decode(body) |> elem(1) |> Map.get("responseTime")    
    %{responseTime: responseTime}
  end
end