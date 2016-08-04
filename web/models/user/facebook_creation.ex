defmodule Talkin.User.FacebookCreation do
  alias Talkin.User
  alias Talkin.UserSession
  alias Talkin.Repo

  def find_or_create_user_by_access_token(oauth_token) do
    user = Repo.get_by(User, oauth_token: oauth_token.access_token)
    if user do
      {:found, user}
    else
      find_by_uid_or_create(oauth_token)
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
    Facebook.get_user!(access_token)
    |> find_by_uid_or_create
  end


  defp create_user(user_params) do
    changeset = User.changeset(%User{},
      %{"uid" => user_params["id"],
        "name" => user_params["name"],
        "oauth_token" => user_params["oauth_token"]})

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:created, user}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_session(conn, user) do
    # %{params: %{"lat" => lat, "long" => long}} = conn
    lat = 85
    long = 85
    changeset = UserSession.changeset(%UserSession{},
                            %{"user_id" => user.id,
                              "location" => Geo.WKT.decode("POINT(#{lat} #{long})")})
    |> Repo.insert
    conn
  end
end
