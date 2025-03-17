defmodule ElixirTemplate.Accounts do
  use Ash.Domain, otp_app: :elixir_template, extensions: [AshAdmin.Domain, AshPhoenix]

  admin do
    show? true
  end

  resources do
    resource ElixirTemplate.Accounts.Token

    resource ElixirTemplate.Accounts.User do
      define :change_password,
        action: :change_password,
        args: [:password, :password_confirmation, :current_password]

      define :change, action: :change
    end
  end
end
