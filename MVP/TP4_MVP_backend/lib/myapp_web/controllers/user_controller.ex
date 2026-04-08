defmodule MyappWeb.UserController do
  use MyappWeb, :controller
  alias Mongo

  @collection "users"

  # GET /api/getTest
  def get_test(conn, _params) do
    json(conn, %{message: "API working"})
  end

  # POST /api/register
  def register(conn, params) do
    with {:ok, username} <- Map.fetch(params, "username"),
         {:ok, password} <- Map.fetch(params, "password") do

      # Vérifier si utilisateur existe
      existing =
        Mongo.find_one(:mongo, @collection, %{username: username})

      if existing do
        conn
        |> put_status(400)
        |> json(%{error: "User already exists"})
      else
        user = %{
          username: username,
          password: password
        }

        case Mongo.insert_one(:mongo, @collection, user) do
          {:ok, _} ->
            json(conn, %{message: "User registered"})

          {:error, reason} ->
            conn
            |> put_status(500)
            |> json(%{error: inspect(reason)})
        end
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{error: "Missing username or password"})
    end
  end

  # POST /api/login
  def login(conn, params) do
    with {:ok, username} <- Map.fetch(params, "username"),
         {:ok, password} <- Map.fetch(params, "password") do

      user =
        Mongo.find_one(:mongo, @collection, %{
          username: username,
          password: password
        })

      if user do
        json(conn, %{
          message: "Login successful",
          user: username
        })
      else
        conn
        |> put_status(401)
        |> json(%{error: "Invalid credentials"})
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{error: "Missing username or password"})
    end
  end
end
