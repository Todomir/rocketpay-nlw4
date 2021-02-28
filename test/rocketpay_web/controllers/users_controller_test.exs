defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true

  describe "create/2" do
    test "when all params are valid, create an user", %{conn: conn} do
      params = %{
        name: "Abner Luis Rodrigues",
        email: "abner@todomir.dev",
        password: "password",
        nickname: "Todomir",
        age: 19
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
        "message" => "User created!",
        "user" => %{
          "account" => %{"balance" => "0.00", "id" => _account_id},
        "age" => 19,
        "email" => "abner@todomir.dev",
        "id" => _user_id,
        "name" => "Abner Luis Rodrigues",
        "nickname" => "Todomir"
        }} = response
    end

    test "when there is invalid params, return an error", %{conn: conn} do
      params = %{
        name: "Abner Luis Rodrigues",
        email: "abner",
        password: "__",
        nickname: "Todomir",
        age: 19
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "email" => ["has invalid format"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end
end
