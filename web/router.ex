defmodule PhoenixBenchmark.Router do
  use PhoenixBenchmark.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    # plug Phoenix.LiveReloader
  end


  scope "/api", PhoenixBenchmark do
    pipe_through :api
    resources "/benchmarks", BenchmarkController
  end
end
