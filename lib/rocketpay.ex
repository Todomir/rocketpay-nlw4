defmodule Rocketpay do
  alias Rocketpay.Users.Create, as: CreateUser
  defdelegate create_user(params), to: CreateUser, as: :call
end
