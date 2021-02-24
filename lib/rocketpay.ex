defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: CreateUser
  alias Rocketpay.Accounts.Deposit

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate deposit(params), to: Deposit, as: :call
end
