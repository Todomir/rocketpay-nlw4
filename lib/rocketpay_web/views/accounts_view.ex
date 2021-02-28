defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  def render(
    "update.json",
    %{ account: %Account{ id: id, balance: balance }}
  )
  do
      %{
        message: "Account updated",
        account: %{
          id: id,
          balance: balance
        }
      }
  end

  def render(
    "transaction.json",
    %{transaction: %TransactionResponse{ to: to, from: from }}
  )
  do
    %{
      message: "Transaction done successfully",
      transaction: %{
        from: %{
          id: from.id,
          balance: from.balance
        },
        to: %{
          id: to.id,
          balance: to.balance
        }
      }
    }
end
end
