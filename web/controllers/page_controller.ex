defmodule Talkin.PageController do
  use Talkin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
