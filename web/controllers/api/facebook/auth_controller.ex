defmodule Talkin.API.Facebook.AuthController do
  use Talkin.Web, :controller

  alias Talkin.User
  require IEx

  def login(conn, %{"access_token" => access_token}) do
    find_or_create_user_by_access_token(access_token)
    |> response(conn)
  end

  defp find_or_create_user_by_access_token(access_token) do
    user = Repo.get_by(User, oauth_token: access_token)
    if user do
      {:found, user}
    else
      find_by_uid_or_create(access_token)
    end
  end

  defp find_by_uid_or_create({:error, error}) do
    {:error, error}
  end

  defp find_by_uid_or_create({:ok, user_params}) do
    find_by_uid_or_create({:user_params, user_params})
  end

  defp find_by_uid_or_create({:user_params, user_params}) do
    user = Repo.get_by(User, uid: user_params["id"])
    if user do
      {:changed_access_token, user}
    else
      create_user(user_params)
    end
  end

  defp find_by_uid_or_create(access_token) do
    response = Facebook.get_user
    |> find_by_uid_or_create
  end


  defp create_user(user_params) do
    changeset = User.changeset(%User{},
      %{"uid" => user_params["id"],
        "name" => user_params["name"],
        "oauth_token" => user_params["access_token"]})

    case Repo.insert(changeset) do
      {:created, user} ->
        {:created, user}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp response({:error, _changeset}, conn) do
  end

  defp response({_, user}, conn) do
    conn
    |> render("login.json", user)
  end
end