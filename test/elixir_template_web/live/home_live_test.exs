defmodule ElixirTemplateWeb.HomeLiveTest do
  use ElixirTemplateWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirTemplate.AccountsFixtures

  describe "Home page" do
    test "redirects if user is not logged in", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/home")
      assert path =~ "/users/log-in"
      
      # Follow the redirect manually
      conn = get(conn, path)
      assert html_response(conn, 200) =~ "Log in"
    end

    test "renders home page for authenticated users", %{conn: conn} do
      user = user_fixture()

      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/home")
      
      # Verify the content is rendered correctly
      assert html =~ "Phoenix Authentication with phx.gen.auth"
      assert html =~ "What is phx.gen.auth?"
      assert html =~ "Key Features"
    end
  end
end
