defmodule Organize do
  use HTTPoison.Base

  def process_url(url) do
    Dotenv.get("API_SERVER") <> "/" <> url
  end

  def process_response_body(body) do
    responseTime = body 
      |> Poison.decode! 
      |> Map.get("data")
      |> Map.get("results") 
      |> Enum.at(1) 
      |> Map.get("score")
    %{score: responseTime}
  end
end