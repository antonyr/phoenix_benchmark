defmodule Detectors do
  use HTTPotion.Base

  def process_url(url) do
    "#{Dotenv.get("API_SERVER")}/#{url}"
  end
end