defmodule CatFeederWeb.PageController do
  use CatFeederWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
