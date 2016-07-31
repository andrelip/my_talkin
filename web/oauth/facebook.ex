defmodule Facebook do
  @moduledoc """
  An OAuth2 strategy for Facebook.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: Facebook,
     site: "https://graph.facebook.com",
     authorize_url: "https://www.facebook.com/dialog/oauth",
     redirect_uri: "http://45.33.102.238/login_confirmation",
     token_url: "/oauth/access_token"]
  end

  # Public API

  def client do
    [client_id: "266262673750500",
     client_secret: "d832ec978bb3254f1d15d69343ecbd1d"]
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  def get_user!(token, fields \\ ["id", "name"]) do
    {:ok, user} = OAuth2.AccessToken.get(token, user_resource_url, fields: encode_fields(fields))
    {:ok, (user.body |> Map.put("oauth_token", token.access_token))}
  end

  # Strategy Callbacks

  def user_resource_url do
    "#{config()[:site]}/me"
  end

  def encode_fields(fields) do
    fields |> Enum.join(",")
  end

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
