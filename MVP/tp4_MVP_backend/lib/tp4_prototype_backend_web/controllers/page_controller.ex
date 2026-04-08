defmodule Tp4PrototypeBackendWeb.PageController do
  use Tp4PrototypeBackendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
