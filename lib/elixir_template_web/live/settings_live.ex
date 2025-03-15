defmodule ElixirTemplateWeb.SettingsLive do
  use ElixirTemplateWeb, :live_view

  import ElixirTemplateWeb.Components.{
    FormWrapper,
    PasswordField,
    EmailField,
    InputField,
    Divider
  }

  def render(assigns) do
    ~H"""
    <div>
      HEYYYY
    </div>
    <.form_wrapper phx-change="validate_change" phx-submit="submit_change" for={@change_form}>
      <input type="hidden" field={@change_form[:id]} readonly />
      <.email_field field={@change_form[:email]} />
      <.input_field field={@change_form[:username]} />
      <.button type="submit" icon="hero-play">Save Changes</.button>
    </.form_wrapper>
    <.divider />
    <%!-- <.form_wrapper phx-change="validate_password" phx-submit="submit_password" for={@password_form}>
      <.password_field show_password field={@password_form[:current_password]} />
      <.password_field show_password field={@password_form[:password]} />
      <.password_field show_password field={@password_form[:password_confirmation]} />
      <.button type="submit" icon="hero-play">Save Changes</.button>
    </.form_wrapper> --%>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    IO.inspect(current_user, label: "Settings Live")

    socket =
      assign(socket,
        password_form: %{} |> to_form(),
        change_form: %{} |> to_form()
      )

    # assign(socket,
    #   password_form: ElixirTemplate.Accounts.form_to_change_password(current_user) |> to_form(),
    #   change_form: ElixirTemplate.Accounts.form_to_change(current_user) |> to_form()
    # )

    {:ok, socket}
  end

  def handle_event("validate_password", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.password_form, params)
    socket = assign(socket, password_form: form)
    {:noreply, socket}
  end

  def handle_event("validate_change", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.change_form, params)
    socket = assign(socket, password_form: form)
    {:noreply, socket}
  end
end
