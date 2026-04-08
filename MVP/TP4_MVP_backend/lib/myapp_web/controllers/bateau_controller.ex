defmodule MyappWeb.BoatController do
  use MyappWeb, :controller
  alias Mongo

  @collection "boats"

  # POST /api/addboat
  def add_boat(conn, params) do
    with {:ok, name} <- Map.fetch(params, "name"),
         {:ok, type} <- Map.fetch(params, "type"),
         {:ok, length} <- Map.fetch(params, "length") do

      boat = %{
        name: name,
        type: type,
        length: length
      }

      case Mongo.insert_one(:mongo, @collection, boat) do
        {:ok, result} ->
          json(conn, %{
            message: "Boat added",
            id: result.inserted_id
          })

        {:error, reason} ->
          conn
          |> put_status(500)
          |> json(%{error: inspect(reason)})
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{error: "Missing parameters (name, type, length)"})
    end
  end

  # GET /api/getboats
  def get_boats(conn, _params) do
    boats =
      Mongo.find(:mongo, @collection, %{})
      |> Enum.to_list()

    json(conn, boats)
  end
end
