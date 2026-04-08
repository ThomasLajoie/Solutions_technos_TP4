defmodule Tp4PrototypeBackendWeb.ErrorJSONTest do
  use Tp4PrototypeBackendWeb.ConnCase, async: true

  test "renders 404" do
    assert Tp4PrototypeBackendWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Tp4PrototypeBackendWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
