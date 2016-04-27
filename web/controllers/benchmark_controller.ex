require IEx

defmodule PhoenixBenchmark.BenchmarkController do
  use PhoenixBenchmark.Web, :controller

  def index(conn, _params) do
    pool_name = :default
    options = [{:timeout, 150000}, {:max_connections, 10000}]
    _ok = :hackney_pool.start_pool(pool_name, options)
    async_output = [&detectors/0, &app_search/0, &search_inside/0]
      |> Enum.map(&Task.async(&1))
      |> Enum.map(&Task.await(&1, 100000))
      |> List.flatten
    sync_out = [organize, spellcheck]
      |> List.flatten
    json conn, async_output ++ sync_out
  end

  defp detectors do
    Detectors.get!("detectors", [], hackney: [pool: :default]).body
  end

  defp app_search do
    AppSearch.get!("app_search", [], hackney: [pool: :default]).body
  end

  defp search_inside do
    SearchInside.get!("search_inside", [], hackney: [pool: :default]).body
  end

  defp organize do
    Organize.get!("organize", [], hackney: [pool: :default]).body
  end

  defp spellcheck do
    SpellCheck.get!("spellcheck", [], hackney: [pool: :default]).body
  end
end