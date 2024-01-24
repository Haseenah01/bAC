defmodule BAC.CustomerValidator do
  import Ecto.Query, warn: false
  alias BAC.Repo

  @email_regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/

  def verify_id_number(idnumber) do
    case String.length(idnumber) do
      13 ->
        {:ok, "Valid email"}

      _ ->
        {:error, "ID number must be exactly 13 characters long"}
    end
  end

  def extract_dob(id) do
    dob_part = String.slice(id, 0..5)

    case Integer.parse(dob_part) do
      {dob, _rest} when dob > 0 ->
        year = div(dob, 10000)
        remaining =  rem(dob, 10000)
        {month, day} = {div(remaining,100),  rem(remaining, 100)}

        formatted_date =
          String.pad_leading(Integer.to_string(year), 2, "0") <>
          "-" <> String.pad_leading(Integer.to_string(month), 2, "0") <>
          "-" <> String.pad_leading(Integer.to_string(day), 2, "0")
        formatted_date

      _ ->
        {:error, "Invalid date of birth"}
    end
  end


  def verify_email(email) do
    case Regex.match?(@email_regex, email) do
      true ->
        {:ok, email}

      false ->
        {:error, "Invalid email format"}
    end
  end


  def verify(phone_number)  do
    case String.length(phone_number) do
      10 ->
        case  String.starts_with?(phone_number, "0") do
          true -> {:ok, "Correct number"}

          false -> {:error, "Phone number must start with '0'"}
        end
      _ ->
        {:error, "Phone number must be 10 digits"}
    end
  end

  def verify(_), do: {:error, "Invalid phone number"}


  defp get_customer_v2(id), do: Repo.get(Customer, id)

  def get_customer_struct_v2(id) do
    case get_customer_v2(id) do
      nil -> {:error, "This customer doesnt exist in our system."}
      customer -> {:ok, customer}
    end
  end


  def check_email(email) do
    case BAC.Repo.get_by(BAC.Customers.Customer, email: email) do
      nil ->
        # Email doesn't exist, you can proceed with your logic here
        {:ok, "Email does not exist."}

      _user ->
        # Email already exists in the database, raise an error or handle accordingly
        {:error, "Email already exists."}
    end
  end

  # def all_validations() do

  # end

  def procheck do


    customer_params =  %{
      "email": "amu1000@gmail.com",
      "dateOfBirth": "2000-10-22",
      "idNumber": "5811111121211",
      "firstName": "Hataluli",
      "lastName": "Randima",
      "phoneNumber": "0727941660"}


      email = customer_params.email
     IO.inspect(email)


      email_stru = Map.get(customer_params, "email")
      IO.inspect(email_stru)
      IO.puts "Hello"

    #   with {:ok, message}<- check_email(email) do

    #     BAC.Workers.CustomerValidatorWorkerPro.new_workflow()
    #   |> BAC.Workers.CustomerValidatorWorkerPro.add(:a, BAC.Workers.CustomerValidatorWorkerPro.new(%{"customer" => customer_params}))
    #   |> BAC.Workers.CustomerValidatorWorkerPro.add(:b, BAC.Workers.CreateCustomerV2WorkerPro.new(%{"customer" => customer_params}), deps: [:a])
    #   |> BAC.Workers.CustomerValidatorWorkerPro.add(:c, BAC.Workers.EmailjobPro1.new(%{"customer" => customer_params}), deps: [:b])
    #   |> Oban.insert_all()
    #   |> IO.inspect()

    # else
    #   {:error, reason} ->
    #     {:error, IO.inspect(reason)}
    # end

      BAC.Workers.CustomerValidatorWorkerPro.new_workflow()
      |> BAC.Workers.CustomerValidatorWorkerPro.add(:a, BAC.Workers.CustomerValidatorWorkerPro.new(%{"customer" => customer_params}))
      |> BAC.Workers.CustomerValidatorWorkerPro.add(:b, BAC.Workers.CreateCustomerV2WorkerPro.new(%{"customer" => customer_params}), deps: [:a])
      |> BAC.Workers.CustomerValidatorWorkerPro.add(:c, BAC.Workers.EmailjobPro1.new(%{"customer" => customer_params}), deps: [:b])
      |> Oban.insert_all()
      |> IO.inspect()

  end
end
