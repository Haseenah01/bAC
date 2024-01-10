defmodule BAC.CustomerValidator do


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
        {:ok, "Email is valid"}

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


 end
