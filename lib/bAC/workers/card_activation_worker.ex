defmodule BAC.Workers.CardActivationWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["card", "customer"]

  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}} = job) do

    email_stru = Map.get(customer_params, "email")
    IO.inspect(email_stru)
    id_stru = Map.get(customer_params, "idNumber")

  end
end
