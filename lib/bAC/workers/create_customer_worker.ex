defmodule BAC.Workers.CreateCustomerWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.CustomerValidator

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["customer", "email"]

  @email_regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/


  @impl true
  def perform(%Oban.Job{args: %{"customer" => customer_params}} = _job) do
   #

    id = Map.get(customer_params, "idNumber")
    dob = BAC.CustomerValidator.validate_and_extract_dob(id) #returns date of birth
    IO.inspect(dob)
    email = Map.get(customer_params, "email")



    customer_params = Map.put(customer_params, :dob, BAC.CustomerValidator.extract_dob(id))
    IO.inspect(customer_params)

    with {:ok, _message1} <- verify_id_number(id),
    {:ok, _message2} <- verify_email(email) do

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


  defp verify_id_number(idnumber) do
    case String.length(idnumber) do
      13 ->
        {:ok, "ID number is valid"}

      _ ->
        {:error, "ID number must be exactly 13 characters long"}
    end
  end



  defp verify_email(email) do
    case Regex.match?(@email_regex, email) do
      true ->
        {:ok, "Email is valid"}

      false ->
        {:error, "Invalid email format"}
    end
  end



  # demostrate the with keyword
  # def add_and_double(a, b) do
  #   with {:ok, result1} <- add(a, b),
  #        {:ok, result2} <- double(result1) do
  #     {:ok, result2}
  #   else
  #     {:error, reason} -> {:error, reason}
  #   end
  # end

  # defp add(a, b) do
  #   if a >= 0 and b >= 0 do
  #     {:ok, a + b}
  #   else
  #     {:error, "Both numbers must be non-negative"}
  #   end
  # end

  # defp double(num) do
  #   if num * 2 > 0 do
  #     {:ok, num * 2}
  #   else
  #     {:error, "Result cannot be zero or negative"}
  #   end
  # end

end
