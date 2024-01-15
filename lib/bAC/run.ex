defmodule BAC.Run do


  import Ecto.Query, warn: false
  alias BAC.Repo

  def hata do
    :ok = Oban.Notifier.listen([:my_app_jobs])
    customer_params =  %{

          "email": "amu1111111@gmail.com",
          "dateOfBirth": "2000-10-22",
          "idNumber": "5811111121211",
          "firstName": "Hataluli",
          "lastName": "Randima",
          "phoneNumber": "511134114511"}

          # customer_params
          # |> BAC.Workers.CreateCustomerWorker.new()
          # |> Oban.insert()
          # |> Oban.await(15_000)

          {:ok, %{id: job_id, state: my_state} = job} = Oban.insert(BAC.Workers.CreateCustomerWorker.new(%{"customer" => customer_params}))

IO.puts("ANOITHER #{my_state}")
    receive do
      {:notification, :my_app_jobs, %{"complete" => ^job_id,"stat" => my_state}} ->
        lasa = IO.inspect(Oban.Job
        |> where([j], j.id == ^job_id)
        |> group_by(:state)
        |> select([j], {j.state})
        |> BAC.Repo.one())

        IO.puts("ANOITHER #{my_state}")
        IO.puts("Other job complete!  #")
    after
      30_000 ->

        IO.puts("ANOITHER #{my_state}")
        IO.puts("Other job didn't finish in 30 seconds!")
    end

  end

  def mama(id) do
   lasa = IO.inspect(Oban.Job
    |> where([j], j.id == ^id)
    |> group_by(:state)
    |> select([j], {j.state})
    |> BAC.Repo.one())

    lasa
  end

#   def verify_id_date_of_birth() do
#     # Extract the date of birth from the ID (assuming it's in the format "YYMMDD")
#     extracted_dob = extract_dob_from_id("0001022902822")
#  IO.inspect(extracted_dob)
#     # Compare the extracted date of birth with the provided date of birth
#     if extracted_dob == "2000-10-22" do
#       IO.puts "Date of birth matches ID. Verification successful."
#       true
#     else
#       IO.puts "Date of birth does not match ID. Verification failed."
#       false
#     end
#   end

#   defp extract_dob_from_id(id_number) do
#     # Assuming the date of birth is represented in the format "YYMMDD"
#     # You may need to adjust this based on the actual format of the ID
#     "19" <> String.slice(id_number, 0, 6)
#   end




  def verify_id_date_of_birth() do
    # Extract the date of birth from the South African ID
    extracted_dob = extract_dob_from_id("0007305224088")

    IO.inspect(extracted_dob)
    # Compare the extracted date of birth with the provided date of birth
    if extracted_dob == "2000-07-30" do
      IO.puts "Date of birth matches ID. Verification successful."
      true
    else
      IO.puts "Date of birth does not match ID. Verification failed."
      false
    end
  end

  defp extract_dob_from_id(id_number) do
    # Assuming the South African ID format is YYMMDD
    # Assuming the South African ID format is YYMMDD
    # Extract the birthdate from the ID number and convert the year to "YYYY"
    year = String.slice(id_number, 0, 2)
    "20" <> year <> String.slice(id_number, 2, 6)
  end


  def generate_said do
    # Generate a random year between 1960 and 2001
    year = :rand.uniform(2002 - 1960 + 1) + 1960

    # Generate a random month and pad with '0' if necessary
    month = Integer.to_string(:rand.uniform(12) + 1) |> String.pad_leading(2, "0")

    # Generate a random day and pad with '0' if necessary
    day = Integer.to_string(:rand.uniform(28) + 1) |> String.pad_leading(2, "0")

    # Create date of birth string
    dob = "#{year}-#{month}-#{day}"

    # Set the date of birth in the environment (assuming some context like Phoenix or other web framework)
    # For standalone script, you may need to adapt this part
    # For example, you could print the dob instead
    IO.puts("Date of Birth: #{dob}")

    # Generate a random sequence of numbers and pad with '0' if necessary
    sequence = Integer.to_string(:rand.uniform(10000)) |> String.pad_leading(4, "0")

    # Generate a random citizenship indicator
    citizenship_indicator = if :rand.uniform() < 0.5, do: "0", else: "1"

    # Generate a random ll value between 1 and 9
    ll = Integer.to_string(:rand.uniform(9) + 1)

    # Get the last two digits of the year
    val_y = Integer.to_string(year) |> String.slice(2..-1)

    # Combine the parts to form a valid South African ID number
    id_number = "#{val_y}#{month}#{day}#{sequence}#{citizenship_indicator}8#{ll}"

    id_number
  end


  def validate_said(id_number, dob) do
    if luhn_valid?(id_number) && date_matches?(id_number, dob) do
      IO.puts("The South African ID number is valid.")
    else
      IO.puts("The South African ID number is not valid.")
    end
  end

  defp luhn_valid?(id_number) do
    id_number
    |> String.to_integer()
    |> to_char_list()
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {digit, index}, acc ->
      acc + if rem(index, 2) == 0, do: digit * 2, else: digit
    end)
    |> rem(10) == 0
  end

  defp date_matches?(id_number, dob) do
    date_part = String.slice(id_number, 1..6)
    date_part == dob
  end



    @existing_accounts MapSet.new()

    def generate_account do
      account_number = generate_random_account_number()

      if exists_in_database?(account_number) do
        generate_account()
      else
        @existing_accounts = MapSet.put(@existing_accounts, account_number)
        account_number
      end
    end

    defp generate_random_account_number do
      constant_digits = "6472"
      remaining_digits = String.duplicate(Integer.to_string(Enum.random(0..9)), 12)

      account_number = constant_digits <> remaining_digits
      String.to_integer(account_number)
    end

    defp exists_in_database?(account_number) do
      MapSet.member?(@existing_accounts, account_number)
    end



  def generate_and_check_account do
    account_number = generate_account()
    IO.puts("Generated Account Number: #{account_number}")
  end

  # defmodule MyApp do
  #   alias AccountGenerator

  #   def generate_and_check_account do
  #     account_number = AccountGenerator.generate_account()
  #     IO.puts("Generated Account Number: #{account_number}")
  #   end
  # end

  # Run the example
  #MyApp.generate_and_check_account()


  import Ecto.Query

  @existing_numbers_query BAC.Accounts.Account
  |> where([a], fragment("? LIKE ?", a.account_number, ^"%6742%"))
  |> select([a], a.account_number)

  defp generate_random_number do
    prefix = "6742"
    random_suffix = Integer.to_string(:rand.uniform(10_000_000_000_000))
    String.pad_leading(random_suffix, 12, "0")
  end

  defp generate_random_suffix do
    Integer.to_string(:rand.uniform(10_000_000_000_000))
    |> String.pad_leading(12, "0")
  end

  def generate_account_number do
    prefix = "6742"
    new_account_number = generate_random_suffix()
   # new_account_number = generate_random_number()

    case BAC.Repo.one(from(a in BAC.Accounts.Account, where: a.account_number == ^new_account_number)) do
      nil ->

        # Account number doesn't exist, insert into the database
       # BAC.Repo.insert!(%YourApp.Accounts{account_number: new_account_number})
        new_account_number

      _existing_number ->
        # Account number already exists, generate a new one
        generate_account_number()
    end
  end


  defp generate_random_card_suffix do
    Integer.to_string(:rand.uniform(10_000_000_000_000))
    |> String.pad_leading(16, "0")
  end

  def generate_card_number do
    prefix = "6742"
    new_card_number = prefix <> generate_random_card_suffix()
   # new_account_number = generate_random_number()

    case BAC.Repo.one(from(a in BAC.Accounts.Card, where: a.card_number == ^new_card_number)) do
      nil ->

        # Account number doesn't exist, insert into the database
       # BAC.Repo.insert!(%YourApp.Accounts{account_number: new_account_number})
        new_card_number

      _existing_number ->
        # Account number already exists, generate a new one
        generate_card_number()
    end
  end



  def generate_random_expiration_date do
    current_date = DateTime.utc_now()

    # Generate a random number of months between 1 and 12
    random_month = :rand.uniform(12) + 1

    # Calculate the future date by adding the random number of months in days
    days_in_future = random_month * 30  # Approximate, as a month can have varying days
    expiration_date = DateTime.add(current_date, days_in_future, :day)

    # Generate a random future year (between the current year and the next 10 years)
    random_year = :rand.uniform(10) + DateTime.utc_now().year()

    # Convert DateTime to NaiveDateTime, set the year, and convert back to DateTime
    expiration_date_with_year = expiration_date
    |> DateTime.to_naive()
    |> NaiveDateTime.put(:year, random_year)
    |> DateTime.from_naive!("Etc/UTC")

    # Format the expiration date as MM/YY
    formatted_date = DateTime.format(expiration_date_with_year, "{0:0#d}/{0:0#H}", :strftime)

    {String.split(formatted_date, "/"), formatted_date}
  end

    def mom do
  # Example usage
  generate_expiration_date()
  # {expiration_date_parts, formatted_date} = generate_random_expiration_date()
  # IO.puts("Random Expiration Date: #{formatted_date}")

    end

    def generate_expiration_date do
      current_year = Date.utc_today().year()
      random_month = Enum.random(1..12)
      random_year = current_year + Enum.random(1..5) # Generating a random year in the next 5 years

      month_string = String.pad_leading(Integer.to_string(random_month), 2, "0")
      year_string = Integer.to_string(random_year)

      # Extract the last two characters of the year string
      year_last_two_digits = String.slice(year_string, -2, 2)

      expiration_date = "#{month_string}/#{year_last_two_digits}"

      IO.puts("Generated Expiration Date: #{expiration_date}")

      expiration_date
    end
end
