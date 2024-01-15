defmodule BAC.Workers.CustomerValidatorWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Worker, queue: :valid, max_attempts: 2, tags: ["customer", "validation"]

  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}} = job) do

    email_stru = Map.get(customer_params, "email")
    IO.inspect(email_stru)
    id_stru = Map.get(customer_params, "idNumber")

    id = Map.get(customer_params, "idNumber")
    email = Map.get(customer_params, "email")
    phoneNumber = Map.get(customer_params, "phoneNumber")

    #  customer_params = Map.put(customer_params, :dateOfBirth, BAC.CustomerValidator.extract_dob(id))
    #  IO.inspect(customer_params)

    with {:ok, _message1} <- BAC.CustomerValidator.verify_id_number(id),
         {:ok, cust_email} <- BAC.CustomerValidator.verify_email(email),
         {:ok, _m} <- BAC.CustomerValidator.verify(phoneNumber) do

      # email = new_email(
      #   to: cust_email,
      #   from: "bac@support.com",
      #   subject: "Customer Verification",
      #   text_body: "You have suscceful registered your account #{cust_email} !!!"
      # )
      # ObMailer.deliver_now(email)


      %{"to" =>  cust_email, "subject" => "Customer Verification", "body" => "You have suscceful registered your account #{cust_email} !!!"}
      |> BAC.Workers.Emailjob.new()
      |> Oban.insert()

      Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Job queue: #{job.attempt}")
      :ok

    else
      {:error, reason} ->
        %{"to" =>  email, "subject" => "Account  verificationation", "body" => "You verification failedyour account #{email} and #{reason} !!!"}
        |> BAC.Workers.Emailjob.new()
        |> Oban.insert()

        Logger.error("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | Job queue: #{job.attempt}")
        {:error, reason}
    end
  #  Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | #{to} | #{state} | #{attempt}")
  end
end
