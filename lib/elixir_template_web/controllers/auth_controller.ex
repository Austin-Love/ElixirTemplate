defmodule ElixirTemplateWeb.AuthController do
  use ElixirTemplateWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    message =
      case activity do
        {:confirm_new_user, :confirm} -> "Your email address has now been confirmed"
        {:password, :reset} -> "Your password has successfully been reset"
        _ -> "You are now signed in"
      end

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    # If your resource has a different name, update the assign name here (i.e :current_admin)
    |> assign(:current_user, user)
    |> put_flash(:info, message)
    |> redirect(to: return_to)
  end

  def failure(conn, activity, reason) do
    # Log the authentication failure details
    require Logger
    Logger.error("Authentication failure: #{inspect(activity)}, reason: #{inspect(reason)}")
    
    message =
      case {activity, reason} do
        {_, %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Forbidden{
             errors: [%AshAuthentication.Errors.CannotConfirmUnconfirmedUser{}]
           }
         }} ->
          """
          You have already signed in another way, but have not confirmed your account.
          You can confirm your account using the link we sent to you, or by resetting your password.
          """
          
        # Invalid credentials (wrong password)
        {{:password, :sign_in}, %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Invalid{errors: errors}
         }} ->
          detailed_errors = inspect(errors)
          Logger.error("Invalid credentials: #{detailed_errors}")
          "Incorrect email or password"
          
        # User not found
        {{:password, :sign_in}, %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Query.NotFound{}
         }} ->
          Logger.error("User not found during sign in attempt")
          "Incorrect email or password"
          
        # Registration errors
        {{:password, :register}, %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Invalid{errors: errors}
         }} ->
          detailed_errors = inspect(errors)
          Logger.error("Registration error: #{detailed_errors}")
          "Registration failed. Please check your information and try again."
          
        # Catch all other errors
        _ ->
          Logger.error("Unhandled authentication error: #{inspect(reason)}")
          "Authentication failed. Please try again or contact support."
      end

    conn
    |> put_flash(:error, message)
    |> redirect(to: ~p"/sign-in")
  end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session()
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end
end
