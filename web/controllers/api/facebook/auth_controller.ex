defmodule Talkin.API.Facebook.AuthController do
  use Talkin.Web, :controller

  alias Talkin.User

  def login(conn, %{"access_token" => access_token}) do
    find_or_create_user_by_access_token(access_token: access_token)
    |> response(conn)
  end

  defp find_or_create_user_by_access_token(%{access_token: access_token}) do
    user = Repo.get_by(User, access_token: access_token)
    if user do
      {:found, user}
    else
      find_by_uid_or_create(access_token: access_token)
    end
  end

  defp find_by_uid_or_create(%{access_token: access_token}) do
    response = HTTPotion.get "httpbin.org/get#{access_token}"
    if HTTPotion.Response.success?(response) do
      %HTTPotion.Response{content: user_params} = response
      |> find_by_uid_or_create(user_params: user_params)
    else
      %HTTPotion.Response{content: user_params} = response
      |> {:error, "Facebook: #{content}"}
    end
  end

  defp find_by_uid_or_create(%{user_params: user_params}) do
    user = Repo.get_by(User, uid: user_params[:uid])
    if user do
      {:changed_access_token, user}
    else
      create_user(user_params: user_params)
    end
  end

  defp create_user(%{user_params: user_params}) do
    # user_params =
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:created, user} ->
        conn
        |> render(user)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp response({:error, changeset}, conn) do
  end

  defp response({_, user}, conn) do
    conn
    |> render(user)
  end
end
