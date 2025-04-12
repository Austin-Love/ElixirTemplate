defmodule ElixirTemplateWeb.UserLive.Registration do
  use ElixirTemplateWeb, :live_view

  alias ElixirTemplate.Accounts
  alias ElixirTemplate.Accounts.User

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm">
        <.header class="text-center">
          Register for an account
          <:subtitle>
            Already registered?
            <.link navigate={~p"/users/log-in"} class="font-semibold text-brand hover:underline">
              Log in
            </.link>
            to your account now.
          </:subtitle>
        </.header>

        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <.input
            field={@form[:username]}
            type="text"
            label="Username"
            autocomplete="username"
            required
            phx-mounted={JS.focus()}
          />
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            autocomplete="email"
            required
          />

          <.button variant="primary" phx-disable-with="Creating account..." class="w-full">
            Create an account
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: ElixirTemplateWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    # Create a changeset that combines email and username validation
    changeset = %User{}
                |> Accounts.change_user_email()
                |> Map.put(:action, :validate)
                |> Ecto.Changeset.cast(%{}, [:username])
                |> Ecto.Changeset.validate_required([:username])

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{user.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    # Combine email and username validation
    email_changeset = Accounts.change_user_email(%User{}, user_params)
    username_changeset = Accounts.change_user_username(%User{}, user_params)
    
    # Merge the changesets
    changeset = 
      email_changeset
      |> Ecto.Changeset.cast(user_params, [:username])
      |> Ecto.Changeset.validate_required([:username])
      |> Map.put(:action, :validate)
      |> Map.put(:errors, email_changeset.errors ++ username_changeset.errors)
      |> Map.put(:valid?, email_changeset.valid? and username_changeset.valid?)
    
    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
