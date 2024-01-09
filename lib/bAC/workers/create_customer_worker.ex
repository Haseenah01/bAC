defmodule BAC.Workers.CreateCustomerWorker do
  alias BAC.Customers
  alias BAC.Customers.Customer
  use Oban.Worker, queue: :default, max_attempts: 3, tags: ["user", "customer"], unique: [period: 60]

  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}}) do
  with {:ok, %Customer{} = customer} <- Customers.create_customer(customer_params) do
    IO.inspect(customer)
    {:ok, customer}
  else
    {:error, reason} -> {:error, reason}
  end
end
end
