defmodule BAC.Workers.CreateCustomerWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["customer", "email"]

  @email_regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/


  @impl true
  def perform(%Oban.Job{state: state,attempt: attempt,args: %{"customer" => customer_params}} = job) do
    IO.puts("HATALULIHATALULIHATALULI")
    email_stru = Map.get(customer_params, "email")

    id_stru = Map.get(customer_params, "idNumber")


    # first verify those params
    with {:ok, message1} <- verify_id_number(id_stru),
    {:ok, message2} <- verify_email(email_stru),
    {:ok, %Customer{} = customer} <- Customers.create_customer(customer_params) do
   IO.inspect("HERER#E")
      email = new_email(
        to: customer.email,
        from: "bac@support.com",
        subject: "Customer Registration",
        text_body: "You have suscceful registered your account #{customer.email} !!!"
      )
      ObMailer.deliver_now(email)
      IO.inspect(customer)

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
