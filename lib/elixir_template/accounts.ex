defmodule ElixirTemplate.Accounts do
  use Ash.Domain, otp_app: :elixir_template, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource ElixirTemplate.Accounts.Token
    resource ElixirTemplate.Accounts.User
  end
end
