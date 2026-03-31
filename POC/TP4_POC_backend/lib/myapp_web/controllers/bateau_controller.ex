defmodule MyappWeb.BateauController do
  use MyappWeb, :controller

  def bateau(conn, params) do
  case Myapp.Mongo.insert_bateau(params) do
    {:ok, _result} ->
      json(conn, %{message: "Bateau inserted", params: params})

    {:error, reason} ->
      conn
      |> put_status(:internal_server_error)
      |> json(%{error: "Insert failed", reason: reason})
  end
end

  def get_test(conn, _params) do
    json(conn, %{
      message: "GET test OK"
    })
  end
end
