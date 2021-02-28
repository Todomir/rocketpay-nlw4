defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  # Deposit tests
  describe "deposit/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Abner Luis Rodrigues",
        email: "abner@todomir.dev",
        password: "password",
        nickname: "Todomir",
        age: 19
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(user_params)
      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make an deposit", %{conn: conn, account_id: account_id} do
      params = %{
        "value" => "500.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "500.00", "id" => _id},
        "message" => "Account updated"
      } = response
    end

    test "when there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{
        "value" => "invalid_value"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Invalid value for operation"}

      assert response == expected_response
    end

    test "when the id does not exist, return an error", %{conn: conn, account_id: _id} do
      params = %{
        "value" => "500.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(
          conn,
          :deposit,
          "5d8bda72-b68a-4e19-908c-91558e76c1d2",
          params
          ))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Account not found"}

      assert response == expected_response
    end
  end

  # Withdraw tests
  describe "withdraw/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Abner Luis Rodrigues",
        email: "abner@todomir.dev",
        password: "password",
        nickname: "Todomir",
        age: 19
      }


      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(user_params)

      account_params = %{
        "id" => account_id,
        "value" => "5000.00"
      }

      {:ok, _account} = Rocketpay.deposit(account_params)
      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make an withdraw", %{conn: conn, account_id: account_id} do
      params = %{
        "value" => "500.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert %{
        "account" => %{"balance" => "4500.00", "id" => _id},
        "message" => "Account updated"
      } = response
    end

    test "when there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{
        "value" => "invalid_value"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Invalid value for operation"}

      assert response == expected_response
    end

    test "when the id does not exist, return an error", %{conn: conn, account_id: _id} do
      params = %{
        "value" => "500.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(
          conn,
          :deposit,
          "5d8bda72-b68a-4e19-908c-91558e76c1d2",
          params
          ))
        |> json_response(:bad_request)

        expected_response = %{"message" => "Account not found"}

      assert response == expected_response
    end
  end

  # Transaction tests
  describe "transaction/1" do
    setup %{conn: conn} do
      from_params = %{
        name: "Abner Luis Rodrigues",
        email: "abner@todomir.dev",
        password: "password",
        nickname: "Todomir",
        age: 19
      }

      to_params = %{
        name: "Antonio Lucas",
        email: "tonho@todomir.dev",
        password: "password",
        nickname: "Tonhão",
        age: 20
      }


      {:ok, %User{account: %Account{id: from_account_id}}} = Rocketpay.create_user(from_params)
      {:ok, %User{account: %Account{id: to_account_id}}} = Rocketpay.create_user(to_params)

      deposit_params = %{
        "id" => from_account_id,
        "value" => "5000.00"
      }

      {:ok, _account} = Rocketpay.deposit(deposit_params)
      {:ok, conn: conn, to: to_account_id, from: from_account_id}
    end

    test "when all params are valid, make an transfer",
    %{conn: conn, to: to_account_id, from: from_account_id} do

      params = %{
        "from" => from_account_id,
        "to" => to_account_id,
        "value" => "50.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:ok)

      assert %{
        "message" => "Transaction done successfully",
        "transaction" => %{
          "from" => %{"balance" => "4950.00", "id" => _from},
          "to" => %{"balance" => "50.00", "id" => _to}
        }
      } = response
    end

    test "when any param is invalid, return an error",
    %{conn: conn, to: to_account_id, from: from_account_id} do

      params = %{
        "from" => from_account_id,
        "to" => to_account_id,
        "value" => "invalid_value"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid value for operation"}

      assert response == expected_response
    end

    test "when one of the accounts does not exist, return an error",
    %{conn: conn, to: _to_account_id, from: from_account_id} do

      params = %{
        "from" => from_account_id,
        "to" => "2832ffa6-61d0-4b51-a27e-580ca980e6e5",
        "value" => "50.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Account not found"}

      assert response == expected_response
    end
  end
end
