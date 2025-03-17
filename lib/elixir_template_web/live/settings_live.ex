defmodule ElixirTemplateWeb.SettingsLive do
  use ElixirTemplateWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto flex flex-col gap-8 p-4">
      <.card
        variant="default"
        space="large"
        rounded="extra_large"
        color="dawn"
        class="shadow-md shadow-neutral-600 "
      >
        <.card_content>
          <.form_wrapper
            for={@profile_form}
            phx-change="validate_profile"
            phx-submit="submit_profile"
            padding="extra_large"
            space="large"
          >
            <.email_field
              field={@profile_form[:email]}
              name={:email}
              label="Change Email"
              variant="shadow"
              color="natural"
            />
            <.text_field
              field={@profile_form[:username]}
              label="Change UserName"
              variant="shadow"
              color="natural"
            />
            <.button type="submit" icon="hero-play">
              Save Changes
            </.button>
          </.form_wrapper>
        </.card_content>
      </.card>

      <.divider color="dawn" />
      <.card
        variant="default"
        space="large"
        rounded="extra_large"
        color="dawn"
        class="shadow-md shadow-neutral-600"
      >
        <.form_wrapper
          phx-change="validate_password"
          phx-submit="submit_password"
          for={@password_form}
          space="large"
          padding="extra_large"
        >
          <ElixirTemplateWeb.CoreComponents.input
            field={@password_form[:current_password]}
            label="Current Password"
            type="password"
          />
          <.password_field
            field={@password_form[:password]}
            label="New Password"
            variant="shadow"
            color="natural"
          />
          <.password_field
            field={@password_form[:password_confirmation]}
            label="Confirm New Password"
            variant="shadow"
            color="natural"
          />
          <.button type="submit" icon="hero-play">Save Changes</.button>
        </.form_wrapper>
      </.card>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      assign(socket,
        password_form: ElixirTemplate.Accounts.form_to_change_password(current_user) |> to_form(),
        profile_form: ElixirTemplate.Accounts.form_to_change(current_user) |> to_form()
      )
      |> assign(:user, current_user)

    {:ok, socket}
  end

  def handle_event("validate_password", params, socket) do
    IO.inspect(params)
    form = AshPhoenix.Form.validate(socket.assigns.password_form, params)
    socket = assign(socket, password_form: form)
    {:noreply, socket}
  end

  def handle_event("validate_profile", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.profile_form, params)
    socket = assign(socket, password_form: form)
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_profile", %{"form" => form_params}, socket) do
    # Submit email/username changes
    IO.inspect(form_params)

    case AshPhoenix.Form.submit(socket.assigns.profile_form,
           params: form_params,
           actor: socket.assigns.current_user
         ) do
      {:ok, updated_user} ->
        # On success, update the user assign and reset the form (to reflect saved state)
        socket =
          socket
          |> put_flash(:info, "Profile updated successfully.")
          |> assign(:user, updated_user)
          |> assign(
            :profile_form,
            ElixirTemplate.Accounts.form_to_change(updated_user) |> to_form()
          )

        {:noreply, socket}

      {:error, form_with_errors} ->
        # On failure, reassign the form with errors to re-render validation messages
        {:noreply, assign(socket, :profile_form, form_with_errors)}
    end
  end

  @impl true
  def handle_event("submit_password", %{"form" => pwd_params}, socket) do
    # Submit password change
    case AshPhoenix.Form.submit(socket.assigns.password_form,
           params: pwd_params,
           actor: socket.assigns.current_user
         ) do
      {:ok, updated_user} ->
        socket =
          socket
          |> put_flash(:info, "Password updated successfully.")
          |> assign(:user, updated_user)
          # Reinitialize the password form (clear the password field after successful change)
          |> assign(
            :password_form,
            ElixirTemplate.Accounts.form_to_change_password(updated_user) |> to_form()
          )

        {:noreply, socket}

      {:error, form_with_errors} ->
        {:noreply, assign(socket, :password_form, form_with_errors)}
    end
  end
end
