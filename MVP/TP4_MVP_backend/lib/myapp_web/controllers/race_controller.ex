defmodule MyappWeb.RaceController do
  use MyappWeb, :controller
  alias Mongo

  @collection "races"

  # POST /api/addrace
  def add_race(conn, params) do
    with {:ok, name} <- Map.fetch(params, "name"),
         {:ok, location} <- Map.fetch(params, "location"),
         {:ok, date} <- Map.fetch(params, "date") do

      race = %{
        name: name,
        location: location,
        date: date
      }

      case Mongo.insert_one(:mongo, @collection, race) do
        {:ok, result} ->
          json(conn, %{
            message: "Race added",
            id: result.inserted_id
          })

        {:error, reason} ->
          IO.inspect(reason, label: "MONGO ERROR")
          conn
          |> put_status(500)
          |> json(%{error: inspect(reason)})
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{error: "Missing parameters (name, location, date)"})
    end
  end

  # GET /api/getraces
  def get_races(conn, _params) do
    races =
      Mongo.find(:mongo, @collection, %{})
      |> Enum.to_list()

    json(conn, races)
  end
end
