defmodule Facebook do
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
end
