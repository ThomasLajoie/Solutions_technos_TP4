defmodule MyappWeb.BoatController do
  use MyappWeb, :controller
  alias Mongo

  @collection "boats"

  # POST /api/addboat
  def add_boat(conn, params) do
    nom          = Map.get(params, "nomBateau")
    numero_voile = Map.get(params, "numeroVoile")
    classe       = Map.get(params, "classeBateau")
    barreur      = Map.get(params, "nomBarreur")

    if nom && numero_voile && classe && barreur do
      boat = %{
        nom: nom,
        noVoile: numero_voile,
        classe: classe,
        NomBarreur: barreur
      }

      case Mongo.insert_one(:mongo, @collection, boat) do
        {:ok, result} ->
          # Convertir BSON.ObjectId en string pour JSON
          json(conn, %{message: "Boat added", id: BSON.ObjectId.encode!(result.inserted_id)})
        {:error, reason} ->
          conn
          |> put_status(500)
          |> json(%{error: inspect(reason)})
      end
    else
      conn
      |> put_status(400)
      |> json(%{error: "Missing parameters (nomBateau, numeroVoile, classeBateau, nomBarreur)"})
    end
  end

  # GET /api/getboats
  def get_boats(conn, _params) do
    boats =
      Mongo.find(:mongo, @collection, %{})
      |> Enum.map(fn boat ->
        %{
          id: BSON.ObjectId.encode!(boat["_id"]), # 🔹 convertir ici aussi
          nom: boat["nom"],
          noVoile: boat["noVoile"],
          classe: boat["classe"],
          NomBarreur: boat["NomBarreur"]
        }
      end)

    json(conn, boats)
  end
end
