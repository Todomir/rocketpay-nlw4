defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)
      update_balance(repo, account, value, operation)
    end)
  end

  # Fetching the account
  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end


  # Adding both values
  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _reason, _operation), do: {:error, "Invalid value for operation"}

  defp exec_operation(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  # Updating the account
  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |> Account.changeset(params)
    |> repo.update()
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> exec_operation(value, operation)
    |> update_account(repo, account)
  end

  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}"
    |> String.to_atom()
  end
end
