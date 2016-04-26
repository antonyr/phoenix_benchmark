require IEx

defmodule PhoenixBenchmark.BenchmarkController do
  use PhoenixBenchmark.Web, :controller

  def index(conn, _params) do
    async_output = [&detectors/0, &app_search/0, &search_inside/0]
      |> Enum.map(&Task.async(&1))
      |> Enum.map(&Task.await(&1, 100000))
      |> Enum.map(&Poison.decode(&1))
      |> Enum.map(&get_response_time(&1))
      |> List.flatten
    sync_out = ~w(organize spellcheck)
      |> Enum.map(&make_sync_call(&1))
      |> Enum.map(&Poison.decode(&1))
      |> Enum.map(&sync_call_parser(&1))
      |> List.flatten
    json conn, async_output ++ sync_out
  end

  defp detectors do
    make_sync_call("detectors")
  end

  defp app_search do
    make_sync_call("app_search")
  end

  defp search_inside do
    make_sync_call("search_inside")
  end

  defp make_sync_call(path) do
    {:ok, %HTTPoison.Response{body: body, headers: _headers, status_code: _status}} = HTTPoison.get "#{Dotenv.get("API_SERVER")}/#{path}", timeout: 1000000, recv_timeout: 100000
    body
  end

  defp sync_call_parser(json) do
    response = elem(json, 1)
    cond do
      Map.has_key?(response, "data") -> %{score: Map.get(response, "data") |> Map.get("results") |> Enum.at(1) |> Map.get("score")}
      true -> %{distance: Map.get(response, "distanceBySuggestion") |> Map.get("thai restaurant mountain view")}
    end
  end

  defp get_response_time(json) do
    response = elem(json, 1)
    response_time = Map.get(response, "responseTime")
    if response_time == nil, do: response_time = Map.get(response, "searchTime")
    cond do
      response_time == nil -> %{score: parse_search_inside_json(response)}
      true -> %{responseTime: response_time}
    end
  end

  defp parse_search_inside_json(response) do
    Map.get(response, "searchInsideResults") |> List.first |> Map.get("hits") |> List.first |> Map.get("score")
  end
end