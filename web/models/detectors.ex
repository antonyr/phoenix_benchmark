# defmodule Detectors do
#   use HTTPotion.Base
#   @response ""

#   def process_url(url) do
#     "#{Dotenv.get("API_SERVER")}/#{url}"
#   end

#   def process1() do
#     %HTTPotion.AsyncResponse{id: pid} = get 'detectors', stream_to: self
#     register_callback(pid)
#   end

#   def body do
#     @response
#   end

#   defp register_callback(pid) do
#     receive do
#       %HTTPotion.AsyncChunk{chunk: chunk, id: pid} -> 
#         @response = @response <> chunk
#         register_callback(pid)
#       %HTTPotion.AsyncEnd{id: _pid} -> 
#         @response
#     end
#   end
# end