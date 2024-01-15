defmodule BAC.Workers.CreateAccountWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer
  alias BAC.Accounts
  alias BAC.Accounts.Account
  alias BAC.Accounts.Card

  import Bamboo.Email

  use Oban.Worker, queue: :crato, max_attempts: 5, tags: ["account", "bank"]

  @impl true
  def perform(%Oban.Job{args: %{"customer_id" => customer_id,"account" => account_params}} = job) do

    with :ok <-  Oban.insert(BAC.Workers.AccountValidatorWorker.new(%{"customer_id" => customer_id, "account" => account_params})),
    {:ok, %Customer{} = customer_struct} <- get_customer_struct_v2(customer_id),
    {:ok, %Account{} = account} <- Accounts.create_account(customer_struct,account_params) do

      %{"to" =>  customer_struct.email, "subject" => "Account Registration", "body" => "You have suscceful registered your account #{customer_struct.email}  this is your id you will use #{customer_struct.id}!!!"}
      |> BAC.Workers.Emailjob.new()
      |> Oban.insert()

    # Oban.Notifier.notify(Oban, :bac_jobs, %{complete: job.id})

     Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Worker: #{job.worker}|Job attempt: #{job.attempt}")

     {:ok, account}

    else
      {:error, reason} ->
        # %{"to" =>  email_stru, "subject" => "Account  registation failed", "body" => "You verification failedyour account #{email_stru} and #{reason} !!!"}
        # |> BAC.Workers.Emailjob.new()
        # |> Oban.insert()
        {:error, IO.inspect(reason)}
    end

  end

  defp get_customer_v2(id), do: Repo.get(Customer, id)

  def get_customer_struct_v2(id) do
    case get_customer_v2(id) do
      nil -> {:error, "This customer doesnt exist in our system."}
      customer -> {:ok, customer}
    end
  end
end
