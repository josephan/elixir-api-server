defmodule ChecksumApi.Router do
  use Plug.Router
  require Logger

  alias ChecksumApi.NumbersController

  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  post("/numbers", do: NumbersController.create(conn))
  delete("/numbers", do: NumbersController.delete(conn))
  get("/numbers/checksum", do: NumbersController.checksum(conn))

  match(_, do: send_resp(conn, 404, "Not Found"))
end
