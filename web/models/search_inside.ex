defmodule SearchInside do
  use HTTPoison.Base

  def process_url(url) do
    Dotenv.get("API_SERVER") <> "/" <> url
  end

  def process_response_body(body) do
    responseTime = body
      |> Poison.decode 
      |> elem(1) 
      |> Map.get("searchInsideResults") 
      |> List.first 
      |> Map.get("hits") 
      |> List.first 
      |> Map.get("score")  
    %{score: responseTime}
  end
end