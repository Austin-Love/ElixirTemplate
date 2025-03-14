
defmodule ElixirTemplateWeb.NavLive do
  import Phoenix.LiveView
  use Phoenix.Component
  use ElixirTemplateWeb, :verified_routes

  alias ElixirTemplate.{ProfileLive, SettingsLive}

  def on_mount(:default, _params, _session, socket) do

    if connected?(socket) do
      # subscribe to topics
    end

    socket =
      case socket.assigns[:current_user] do
        %{} = _user ->
          socket
          |> assign(:links, [bp(~p"/", "Home"), bp(~p"/settings", "Settings")])

        _ ->
          assign(socket, :links, [])
      end

    {
      :cont,
      socket
    }
  end

  defp bp(path, label) do
    id = "root-nav-link-#{label}"
    %{path: path, label: label, id: id}
  end

  defp handle_active_tab_params(params, _url, socket) do
    active_tab =
      case {socket.view, socket.assigns.live_action} do
        {ProfileLive, _} ->
          if params["profile_username"] == current_user_profile_username(socket) do
            :profile
          end

        {SettingsLive, _} ->
          :settings

        {_, _} ->
          nil
      end

    {:cont, assign(socket, active_tab: active_tab)}
  end

  defp current_user_profile_username(socket) do
    if user = socket.assigns.current_user do
      user.username
    end
  end
end
