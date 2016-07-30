defmodule Facebook do
  def get_user do
    HTTPotion.get(request_url(sample_token))
    |> parse_response(sample_token)
  end

  def get_user(access_token) do
    response = HTTPotion.get(request_url(access_token))
    if HTTPotion.Response.success? response do
      parse_response(response, access_token)
    else
      {:error, "facebook reject token"}
    end
  end

  defp parse_response(%{body: body}, access_token) do
    Poison.decode!(body)
    |> Map.put("access_token", access_token)
    |> render_ok
  end

  defp render_ok(user_params) do
    {:ok, user_params}
  end

  defp request_url(access_token) do
    "#{facebook_url}?#{fields}&access_token=#{access_token}"
  end

  defp facebook_url do
    "https://graph.facebook.com/me"
  end

  defp fields do
    "fields=id,name"
  end

  defp sample_token do
    "EAADyKhwVZBeQBAIcbShR0okeg6EkcaAx21bCMWtiUPdTjB5K0RI30lGrQu833suGbkofxE0z6emFAJzOLvNircruxH4zvJjCY1oIwtZCQ6g6aS5aq5DZALUyZB3KRs9DHelHWzXt6DEfP7cAu3NxfB4ZCHw9VYuZBR8a13I7ITvQNpdquiojHYJreZCIqjbDJBMTJcvm4349Uw4z0UKZCuKA"
  end
end
