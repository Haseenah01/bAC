defmodule BAC.Workers.CreateCustomerV2Worker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["customer", "email"]

  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}} = job) do

    email_stru = Map.get(customer_params, "email")
    Logger.info(email_stru)
    id_stru = Map.get(customer_params, "idNumber")

   # with {:ok, %Oban.Job{} = job} <-  Oban.insert(BAC.Workers.CustomerValidatorWorker.new(%{"customer" => customer_params})),
    with {:ok, %Customer{} = customer} <- Customers.create_customer(customer_params) do

      %{"to" =>  customer.email, "subject" => "Account Registration", "body" => "You have suscceful registered your account #{customer.email}  this is your id you will use #{customer.id}!!!"}
      |> BAC.Workers.Emailjob.new()
      |> Oban.insert()

     Oban.Notifier.notify(Oban, :bac_jobs, %{complete: job.id})

     Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Worker: #{job.worker}|Job attempt: #{job.attempt}")

     {:ok, customer}

    else
      {:error, reason} ->
        %{"to" =>  email_stru, "subject" => "Account  registation failed", "body" => "You verification failedyour account #{email_stru} and #{reason} !!!"}
        |> BAC.Workers.Emailjob.new()
        |> Oban.insert()
        {:error, Logger.info(reason)}
    end


  end
end
