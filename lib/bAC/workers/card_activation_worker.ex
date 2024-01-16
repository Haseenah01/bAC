defmodule BAC.Workers.CardActivationWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer
  alias BAC.Accounts
  alias BAC.Accounts.Card
  alias BAC.Customers.Customer
  alias BAC.Accounts.Account

  import Ecto.Query, warn: false
  alias BAC.Repo

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["card", "bank"]

  @impl true
  def perform(%Oban.Job{args: %{"account_struct" => account_struct1, "card_params" => card_params1}} = job) do


    IO.puts("start")

    IO.inspect(account_struct1)
    IO.inspect(card_params1)

    with {:ok, %Card{} = card} <- Accounts.create_card(account_struct1, card_params1) do

    #   %{"to" =>  customer.email, "subject" => "Account Registration", "body" => "You have suscceful registered your account #{customer.email}  this is your id you will use #{customer.id}!!!"}
    #   |> BAC.Workers.Emailjob.new()
    #   |> Oban.insert()

    #  Oban.Notifier.notify(Oban, :bac_jobs, %{complete: job.id})
     IO.puts("Card activated")
     Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Worker: #{job.worker}|Job attempt: #{job.attempt}")

     {:ok, card}

    else
      {:error, reason} ->
        # %{"to" =>  email_stru, "subject" => "Account  registation failed", "body" => "You verification failedyour account #{email_stru} and #{reason} !!!"}
        # |> BAC.Workers.Emailjob.new()
        # |> Oban.insert()
        {:error, IO.inspect(reason)}
    end
  end
end
