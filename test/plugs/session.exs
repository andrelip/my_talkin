# test/plugs/require_login_test.exs

defmodule Talkin.Plugs.Session do
  use Talkin.ConnCase

  test "it should fetch User" do
    # build a connection and run the plug

    conn |> assign(:current_user, %Talkin.User{})
  end
end
