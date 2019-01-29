defmodule ChecksumApi.NumbersController do
  import Plug.Conn

  def create(%{body_params: %{"number" => number}} = conn) when is_number(number) do
    numbers = [1,2,3]
    new_numbers = [number | numbers]

    conn
    |> json(201, %{numbers: new_numbers})
  end

  def create(conn) do
    conn
    |> json(422, %{error: "missing or invalid number parameter"})
  end

  def delete(conn) do
    conn
    |> json(200)
  end

  def checksum(conn) do
    conn
    |> json(200, %{checksum: 100})
  end

  defp json(conn, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, "")
  end

  defp json(conn, status, map) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(map))
  end
end
