defmodule SpellCheck do
  use HTTPoison.Base

  def process_url(url) do
    Dotenv.get("API_SERVER") <> "/" <> url
  end

  def process_response_body(body) do
    responseTime = body
      |> Poison.decode!
      |> Map.get("distanceBySuggestion") 
      |> Map.get("thai restaurant mountain view")
    %{distance: responseTime}
  end
end