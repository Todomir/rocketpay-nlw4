defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, return an user" do
      params = %{
        name: "Abner Luis Rodrigues",
        email: "abner@todomir.dev",
        password: "password",
        nickname: "Todomir",
        age: 19
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %{
        email: "abner@todomir.dev",
        nickname: "Todomir",
        id: ^user_id
      } = user
    end
    test "when there are invalid params, return an error" do
      params = %{
        name: "Abner Luis Rodrigues",
        email: "abner",
        password: "__",
        nickname: "Todomir",
        age: 19
      }

      {:error, changeset} = Create.call(params)
      expected_response = %{
        email: ["has invalid format"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
