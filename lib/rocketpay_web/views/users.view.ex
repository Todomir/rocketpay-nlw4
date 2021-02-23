defmodule RocketpayWeb.UsersView do
  alias Rocketpay.User
  def render(
    "create.json",
    %{user: %User{id: id, name: name, nickname: nickname, email: email, age: age}
  }) do

    %{
      message: "User created!",
      user: %{
        id: id,
        name: name,
        age: age,
        email: email,
        nickname: nickname
      }
    }

  end
end
