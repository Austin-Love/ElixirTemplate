defmodule ElixirTemplateWeb.NavLive do
  import Phoenix.LiveView
  use Phoenix.Component
  use ElixirTemplateWeb, :verified_routes

  def on_mount(:default, _params, _session, socket) do
    if connected?(socket) do
      # subscribe to topics
    end

    socket = assign(socket, :links, [])

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
end
