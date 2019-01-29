defmodule ChecksumApi.NumbersController do
  import Plug.Conn

  alias ChecksumApi.NumberStore

  def create(%{body_params: %{"number" => number}} = conn) when is_number(number) do
    {:ok, numbers} = NumberStore.add_number(number)

    json(conn, 201, %{numbers: numbers})
  end

  def create(conn) do
    json(conn, 422, %{error: "missing or invalid number parameter"})
  end

  def delete(conn) do
    :ok = NumberStore.clear_numbers()

    json(conn, 200)
  end

  def checksum(conn) do
    {:ok, checksum} = NumberStore.get_checksum()

    json(conn, 200, %{checksum: checksum})
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
