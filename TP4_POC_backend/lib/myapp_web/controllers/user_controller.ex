defmodule MyappWeb.UserController do
  use MyappWeb, :controller

  def users(conn, params) do
  case Myapp.Mongo.insert_user(params) do
    {:ok, _result} ->
      json(conn, %{message: "User inserted", params: params})

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
