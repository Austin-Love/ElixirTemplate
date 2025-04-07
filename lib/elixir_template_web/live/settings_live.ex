defmodule ElixirTemplateWeb.SettingsLive do
  use ElixirTemplateWeb, :live_view
  import ElixirTemplateWeb.Components.RadioField

  @impl true

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto flex flex-col gap-8 p-6 bg-primaryBg-light dark:bg-primaryBg-dark text-primaryText-light dark:text-primaryText-dark">
      <h1 class="text-2xl font-semibold mb-4 text-primaryText-light dark:text-primaryText-dark">Account Settings</h1>

      <div class="shadow-md border border-neutral-200 dark:border-neutral-700 bg-primaryBg-light dark:bg-primaryBg-dark rounded-extra_large">
        <div class="p-4">
          <h2 class="text-xl font-medium text-primaryText-light dark:text-primaryText-dark">Profile Information</h2>
          <p class="text-sm text-secondaryText-light dark:text-secondaryText-dark">Update your account's profile information.</p>
        </div>
        <div class="p-4">
          <.form_wrapper
            for={@profile_form}
            phx-change="validate_profile"
            phx-submit="submit_profile"
            padding="large"
            space="large"
          >
            <.email_field
              field={@profile_form[:email]}
              name={:email}
              label="Email Address"
              variant="shadow"
              color="natural"
              placeholder="your.email@example.com"
            />
            <.text_field
              field={@profile_form[:username]}
              label="Username"
              variant="shadow"
              color="natural"
              placeholder="your_username"
            />
            <div class="flex justify-end mt-4">
              <.button type="submit" class="bg-primaryAccent-light dark:bg-primaryAccent-dark hover:bg-primaryAccent-light/90 dark:hover:bg-primaryAccent-dark/90 text-primaryBg-light dark:text-primaryBg-dark" icon="hero-check">
                Save Changes
              </.button>
            </div>
          </.form_wrapper>
        </div>
      </div>

      <div class="shadow-md border border-neutral-200 dark:border-neutral-700 bg-secondaryBg-light dark:bg-secondaryBg-dark rounded-extra_large">
        <div class="p-4">
          <h2 class="text-xl font-medium text-primaryText-light dark:text-primaryText-dark">Theme Preferences</h2>
          <p class="text-sm text-secondaryText-light dark:text-secondaryText-dark">Customize your application appearance.</p>
        </div>
        <div class="p-4">
          <.form_wrapper
            for={@theme_form}
            phx-change="update_theme"
            phx-submit="save_theme"
            space="large"
            padding="large"
          >
            <div class="flex flex-col space-y-4">
              <p class="text-secondaryText-light dark:text-secondaryText-dark mb-2">Choose your preferred appearance:</p>
              <div class="bg-secondaryBg-light dark:bg-secondaryBg-dark p-4 rounded-lg">
                <.group_radio
                  name="theme_preference"
                  color="natural"
                  size="medium"
                  space="large"
                  class="flex flex-col md:flex-row md:space-x-6 space-y-3 md:space-y-0"
                  label_class="text-primaryText-light dark:text-primaryText-dark"
                >
                  <:radio
                    value="light"
                    checked={@current_user.theme_preference == "light"}
                  >
                    <div class="flex items-center">
                      <div class="mr-2 h-4 w-4 rounded-full bg-primaryBg-light border border-secondaryText-light/20"></div>
                      Light
                    </div>
                  </:radio>
                  <:radio
                    value="dark"
                    checked={@current_user.theme_preference == "dark"}
                  >
                    <div class="flex items-center">
                      <div class="mr-2 h-4 w-4 rounded-full bg-primaryBg-dark border border-secondaryText-dark/20"></div>
                      Dark
                    </div>
                  </:radio>
                  <:radio
                    value="system"
                    checked={@current_user.theme_preference == "system"}
                  >
                    <div class="flex items-center">
                      <div class="mr-2 h-4 w-4 rounded-full bg-gradient-to-r from-primaryBg-light to-primaryBg-dark border border-secondaryText-light/20"></div>
                      System
                    </div>
                  </:radio>
                </.group_radio>
              </div>
              <div class="flex justify-end mt-4">
                <.button type="submit" class="bg-primaryAccent-light dark:bg-primaryAccent-dark hover:bg-primaryAccent-light/90 dark:hover:bg-primaryAccent-dark/90 text-primaryBg-light dark:text-primaryBg-dark" icon="hero-sparkles">
                  Save Theme
                </.button>
              </div>
            </div>
          </.form_wrapper>
        </div>
      </div>

      <div class="shadow-md p-4 border border-neutral-200 dark:border-neutral-700 bg-primaryBg-light dark:bg-primaryBg-dark rounded-extra_large">
        <div class="p-4">
          <h2 class="text-xl font-medium text-primaryText-light dark:text-primaryText-dark">Update Password</h2>
          <p class="text-sm text-secondaryText-light dark:text-secondaryText-dark">Ensure your account is using a secure password.</p>
        </div>
        <div class="p-4">
          <.form_wrapper
            phx-change="validate_password"
            phx-submit="submit_password"
            for={@password_form}
            space="large"
            padding="large"
          >
            <.password_field
              field={@password_form[:current_password]}
              label="Current Password"
              variant="shadow"
              color="natural"
              placeholder="••••••••"
            />
            <.password_field
              field={@password_form[:password]}
              label="New Password"
              variant="shadow"
              color="natural"
              placeholder="••••••••"
            />
            <.password_field
              field={@password_form[:password_confirmation]}
              label="Confirm New Password"
              variant="shadow"
              color="natural"
              placeholder="••••••••"
            />
            <div class="flex justify-end mt-4">
              <.button type="submit" class="bg-primaryAccent-light dark:bg-primaryAccent-dark hover:bg-primaryAccent-light/90 dark:hover:bg-primaryAccent-dark/90 text-primaryBg-light dark:text-primaryBg-dark" icon="hero-key">
                Update Password
              </.button>
            </div>
          </.form_wrapper>
        </div>
      </div>
    </div>
    """
  end


  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      assign(socket,
        password_form: ElixirTemplate.Accounts.form_to_change_password(current_user) |> to_form(),
        profile_form: ElixirTemplate.Accounts.form_to_change(current_user) |> to_form(),
        theme_form: to_form(%{"theme_preference" => current_user.theme_preference || "system"})
      )
      |> assign(:user, current_user)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_password", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.password_form, params)
    socket = assign(socket, password_form: form)
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_theme", %{"theme_preference" => theme}, socket) do
    # This immediately updates the UI when the user selects a theme
    socket = push_event(socket, "apply-theme", %{theme: theme})
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_theme", %{"theme_preference" => theme}, socket) do
    current_user = socket.assigns.current_user

    case ElixirTemplate.Accounts.update(current_user, %{theme_preference: theme}) do
      {:ok, updated_user} ->
        socket =
          socket
          |> put_flash(:info, "Theme preference saved.")
          |> assign(:current_user, updated_user)
          |> assign(:user, updated_user)
          |> push_event("apply-theme", %{theme: theme})
          |> push_event("store-theme", %{theme: theme})

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Failed to save theme preference.")

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate_profile", params, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.profile_form, params)
    socket = assign(socket, profile_form: form)
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_profile", %{"form" => form_params}, socket) do
    # Submit email/username changes

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
