defmodule BAC.Workers.CreateCustomerWorker do
  require Logger
  alias BAC.ObMailer

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["customer", "email"]




  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}} = _job) do
   #

    id = Map.get(customer_params, "idNumber")
    email = Map.get(customer_params, "email")
    phoneNumber = Map.get(customer_params, "phoneNumber")



     customer_params = Map.put(customer_params, :dateOfBirth, BAC.CustomerValidator.extract_dob(id))
     IO.inspect(customer_params)

    with {:ok, _message1} <- BAC.CustomerValidator.verify_id_number(id),
         {:ok, _message2} <- BAC.CustomerValidator.verify_email(email),
         {:ok, _m} <- BAC.CustomerValidator.verify(phoneNumber) do

      email = new_email(
        to: email,
        from: "bac@support.com",
        subject: "Customer Registration",
        text_body: "You have suscceful registered your account #{email} !!!"
      )
      ObMailer.deliver_now(email)
      #IO.inspect(customer)
    #{:ok, customer}

    else
      {:error, reason} -> {:error, reason}
    end
  #  Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | #{to} | #{state} | #{attempt}")





  end



end
