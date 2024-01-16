defmodule BAC.Workers.AccountValidatorWorker do
  require Logger

  import Ecto.Query, warn: false
  alias BAC.Repo

  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Worker, queue: :valid, max_attempts: 2, tags: ["customer", "validation"]

  @impl true
  def perform(%Oban.Job{args: %{"customer_id" => customer_id, "account" => account_params}} = job) do

   balance_par = Map.get(account_params,"balance")
   with {:ok, balance} <- verify_balance(balance_par),
   #{:ok, cust} <- get_customer_struct_v2(customer_id),
   {:ok, job1} <-  Oban.insert(BAC.Workers.CreateAccountWorker.new(%{"customer_id" => customer_id, "account" => account_params})) do

    IO.puts("Verification successful")

    :ok
   else
    {:error, reason} -> {:error, IO.inspect(reason)}
   end

  end

  defp get_customer_v2(id), do: Repo.get(Customer, id)

  def get_customer_struct_v2(id) do
    case get_customer_v2(id) do
      nil -> {:error, "This customer doesnt exist in our system."}
      customer -> {:ok, customer}
    end
  end

  defp verify_balance(bal) do

      if bal  < 0 do
        {:error, "Negative balance not allowed"}
      else
        {:ok, bal }
      end

  end
end
