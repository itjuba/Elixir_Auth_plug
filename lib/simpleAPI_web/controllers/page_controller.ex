defmodule SimpleAPIWeb.PageController do
  use SimpleAPIWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
