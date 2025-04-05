defmodule ElixirTemplateWeb.Auth.SignInLive do
  use ElixirTemplateWeb, :live_view
  alias ElixirTemplateWeb.Auth.AuthHelpers
  import Phoenix.Component
  alias ElixirTemplateWeb.CoreComponents

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Sign In")
      |> assign(:password_form, AuthHelpers.password_sign_in_form(socket) |> to_form())
      |> assign(:magic_link_form, AuthHelpers.magic_link_form(socket) |> to_form())
      |> assign(:active_tab, "password")
      |> assign(:error_message, nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <img class="mx-auto h-10 w-auto" src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600" alt="Your Company">
        <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-primaryText-light dark:text-primaryText-dark">Sign in to your account</h2>
      </div>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
        <div class="mb-4 border-b border-gray-200 dark:border-gray-700">
          <ul class="flex flex-wrap -mb-px text-sm font-medium text-center" role="tablist">
            <li class="mr-2" role="presentation">
              <button
                class={[
                  "inline-block p-4 border-b-2 rounded-t-lg",
                  @active_tab == "password" && "text-primaryAccent-light dark:text-primaryAccent-dark border-primaryAccent-light dark:border-primaryAccent-dark"
                ]}
                phx-click="switch-tab"
                phx-value-tab="password"
              >
                Password
              </button>
            </li>
            <li class="mr-2" role="presentation">
              <button
                class={[
                  "inline-block p-4 border-b-2 rounded-t-lg",
                  @active_tab == "magic_link" && "text-primaryAccent-light dark:text-primaryAccent-dark border-primaryAccent-light dark:border-primaryAccent-dark"
                ]}
                phx-click="switch-tab"
                phx-value-tab="magic_link"
              >
                Magic Link
              </button>
            </li>
          </ul>
        </div>

        <div class="tab-content">
          <div class={["tab-pane", @active_tab != "password" && "hidden"]}>
            <.form for={@password_form} phx-change="validate_password" phx-submit="sign_in_with_password">
              <div class="space-y-4">
                <CoreComponents.input
                  field={@password_form[:email]}
                  type="email"
                  label="Email address"
                  required
                  autocomplete="email"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />
                
                <CoreComponents.input
                  field={@password_form[:password]}
                  type="password"
                  label="Password"
                  required
                  autocomplete="current-password"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />
                
                <div class="mt-2 text-sm text-red-600 dark:text-red-400">
                  <%= if @error_message do %>
                    <p><%= @error_message %></p>
                  <% end %>
                </div>
                
                <div class="mt-6">
                  <button
                    type="submit"
                    class="flex w-full justify-center rounded-md bg-primaryAccent-light dark:bg-primaryAccent-dark px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-primary-500 dark:hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primaryAccent-light dark:focus-visible:outline-primaryAccent-dark"
                  >
                    Sign in
                  </button>
                </div>
              </div>
            </.form>
          </div>

          <div class={["tab-pane", @active_tab != "magic_link" && "hidden"]}>
            <.form for={@magic_link_form} phx-change="validate_magic_link" phx-submit="request_magic_link">
              <div class="space-y-4">
                <CoreComponents.input
                  field={@magic_link_form[:email]}
                  id="magic_link_email"
                  type="email"
                  label="Email address"
                  required
                  autocomplete="email"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />
                
                <div class="mt-2 text-sm text-red-600 dark:text-red-400">
                  <%= if @error_message do %>
                    <p><%= @error_message %></p>
                  <% end %>
                </div>
                
                <div class="mt-6">
                  <button
                    type="submit"
                    class="flex w-full justify-center rounded-md bg-primaryAccent-light dark:bg-primaryAccent-dark px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-primary-500 dark:hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primaryAccent-light dark:focus-visible:outline-primaryAccent-dark"
                  >
                    Send Magic Link
                  </button>
                </div>
              </div>
            </.form>
          </div>
        </div>

        <p class="mt-10 text-center text-sm text-secondaryText-light dark:text-secondaryText-dark">
          Not a member?
          <a href="/register" class="font-semibold leading-6 text-primaryAccent-light dark:text-primaryAccent-dark hover:text-primary-500 dark:hover:text-primary-400">
            Register now
          </a>
        </p>
      </div>
    </div>
    """
  end

  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def handle_event("validate_password", %{"form" => form_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.password_form.source, %{"form" => form_params}) |> to_form()
    {:noreply, assign(socket, :password_form, form)}
  end

  def handle_event("validate_magic_link", %{"form" => form_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.magic_link_form.source, %{"form" => form_params}) |> to_form()
    {:noreply, assign(socket, :magic_link_form, form)}
  end

  def handle_event("sign_in_with_password", params, socket) do
    case AshPhoenix.Form.submit(socket.assigns.password_form.source, params: params["form"]) do
      {:ok, result} ->
        # Redirect to auth controller which will handle the session
        {:noreply,
         socket
         |> redirect(to: ~p"/auth/user/password/success?token=#{result.token}")}

      {:error, form} ->
        {:noreply, socket |> assign(:password_form, to_form(form)) |> assign(:error_message, "Invalid email or password")}
    end
  end

  def handle_event("request_magic_link", params, socket) do
    case AshPhoenix.Form.submit(socket.assigns.magic_link_form.source, params: params["form"]) do
      {:ok, _result} ->
        {:noreply,
         socket
         |> put_flash(:info, "Magic link sent! Check your email.")
         |> redirect(to: ~p"/")}
        
      {:error, form} ->
        {:noreply, socket |> assign(:magic_link_form, to_form(form)) |> assign(:error_message, "Failed to send magic link")}
    end
  end
end
