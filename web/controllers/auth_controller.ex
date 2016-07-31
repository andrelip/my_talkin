defmodule Talkin.AuthController do
  use Talkin.Web, :controller
  alias Talkin.User.FacebookCreation

  def facebook_login(conn, _params) do
    redirect conn, external: Facebook.authorize_url!
  end

  def facebook_callback(conn, %{"code" => code}) do
    oauth_token = Facebook.get_token!(code: code)
    user = FacebookCreation.find_or_create_user_by_access_token(oauth_token)
    case user do
      {:error, changeset} ->
        {:error, changeset}
      {_positive_status, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: "/")
        conn |> redirect(to: "/") |> halt()
    end
  end
end
