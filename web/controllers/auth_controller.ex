defmodule Talkin.AuthController do
  use Talkin.Web, :controller

  def facebook_login(conn, _params) do
    redirect conn, external: FacebookInternal.authorize_url!
  end

  def facebook_callback(conn, %{"code" => code}) do
    token = FacebookInternal.get_token!(code: code)
    user = FacebookInternal.get_user!(token)
  end
end
