require IEx

defmodule PhoenixBenchmark.BenchmarkController do
  use PhoenixBenchmark.Web, :controller

  def index(conn, _params) do
    async_output = ~w(detectors app_search search_inside)
      |> Enum.map(&make_calls(&1))
      |> Enum.map(&register_callback(&1))
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

  defp make_sync_call(path) do
    %HTTPotion.Response{body: body, headers: _headers} = HTTPotion.get "#{Dotenv.get("API_SERVER")}/#{path}"
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

  defp make_calls(path) do
    %HTTPotion.AsyncResponse{id: _pid} = HTTPotion.get "#{Dotenv.get("API_SERVER")}/#{path}", [stream_to: self]
  end

  defp register_callback(pid, response \\ "") do
    receive do
      %HTTPotion.AsyncChunk{chunk: chunk, id: pid} -> register_callback(pid, response <> chunk)
      %HTTPotion.AsyncEnd{id: _pid} -> 
        if response == "" do
          IEx.pry
        end
        response
    end
  end
end