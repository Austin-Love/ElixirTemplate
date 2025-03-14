defmodule ElixirTemplateWeb.SettingsLive do
  use ElixirTemplateWeb, :live_view
  import ElixirTemplateWeb.Components.{FormWrapper, PasswordField, EmailField, InputField}

  def render(assigns) do
    ~H"""
    <.form_wrapper phx-change="validate_email" phx-submit="submit_email" for={@email_form}>
    <input type="hidden" field={@email_form[:id]} readonly/>
      <.email_field field={@email_form[:email]} />
      <.button type="submit" icon="hero-play"> Save Changes </.button>
    </.form_wrapper>
    <.divider />
    <.form_wrapper phx-change="validate_username" phx-submit="submit_username" for={@username_form}>
      <.input_field field={@username_form[:username]}/>
      <.button type="submit" icon="hero-play"> Save Changes </.button>
    </.form_wrapper>
    <.divider />
    <.form_wrapper phx-change="validate_password" phx-submit="submit_password" for={@password_form}>
      <.password_field show_password field={@password_form[:current_password]}/>
      <.password_field show_password field={@password_form[:password]}/>
      <.password_field show_password field={@password_form[:password_confirmation]}/>
      <.button type="submit" icon="hero-play"> Save Changes </.button>
    </.form_wrapper>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        password_form: AshPhoenix.Form.form_to_change_password |> to_form(),
        email_form: AshPhoenix.Form.form_to_change_email |> to_form(),
        username_form: AshPhoenix.Form.form_to_change_username |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("validate_username", params, socket) do
   form = AshPhoenix.Form.validate(socket.assigns.username_form, params)
    socket = assign(socket, username_form: form)
    {:noreply, socket}
  end

  def handle_event("validate_password", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.password_form, params)
     socket = assign(socket, password_form: form)
     {:noreply, socket}
   end

  def handle_event("validate_email", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.email_form, params)
     socket = assign(socket, email_form: form)
     {:noreply, socket}
   end

end
