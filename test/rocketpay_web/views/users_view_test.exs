defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Abner Luis Rodrigues",
      email: "abner@todomir.dev",
      password: "password",
      nickname: "Todomir",
      age: 19
    }

    {
      :ok,
      %User{
        id: user_id,
        account: %Account{id: account_id}
      } = user
    } = Rocketpay.create_user(params)


    response = render(UsersView, "create.json", user: user)
    expected_response = %{
      message: "User created!",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
      },
      age: 19,
      email: "abner@todomir.dev",
      id: user_id,
      name: "Abner Luis Rodrigues",
      nickname: "Todomir"
      }}
    assert response == expected_response
  end
end
