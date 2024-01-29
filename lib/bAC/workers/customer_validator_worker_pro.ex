defmodule BAC.Workers.CustomerValidatorWorkerPro do

  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Pro.Workers.Workflow, queue: :valid, priority: 3, max_attempts: 2, tags: ["customer", "validation"]

  @impl true
  def process(%Oban.Job{args: %{"customer" => customer_params}} = job) do

    email_stru = Map.get(customer_params, "email")
    Logger.info(email_stru)
    id_stru = Map.get(customer_params, "idNumber")

    id = Map.get(customer_params, "idNumber")
    email = Map.get(customer_params, "email")
    phoneNumber = Map.get(customer_params, "phoneNumber")

    with {:ok, _message1} <- BAC.CustomerValidator.verify_id_number(id),
         {:ok, cust_email} <- BAC.CustomerValidator.verify_email(email),
         {:ok, _m} <- BAC.CustomerValidator.verify(phoneNumber)  do
         #{:ok, job} <- Oban.insert(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})) do


      %{"to" =>  cust_email, "subject" => "Customer Verification", "body" => "You have suscceful verified your account #{cust_email} !!!"}
      |> BAC.Workers.Emailjob.new()
      |> Oban.insert()

     # Logger.info("hata Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Job queue: #{job.attempt}")
      :ok

    else
      {:error, reason} ->
        %{"to" =>  email, "subject" => "Account  verificationation", "body" => "You verification failedyour account #{email} and #{reason} !!!"}
        |> BAC.Workers.Emailjob.new()
        |> Oban.insert()

        Logger.error("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Job queue: #{job.attempt}")
        {:error, Logger.info(reason)}
    end

  end
end
