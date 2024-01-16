defmodule BAC.Workers.CardValidatorWorker do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  alias BAC.Accounts
  alias BAC.Accounts.Account
  alias BAC.Accounts.Card

  import Ecto.Query, warn: false
  alias BAC.Repo

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["card", "customer"]

  @impl true
  def perform(%Oban.Job{args: %{"id" => id}} = job) do

   # account_struct = BAC.Accounts.get_account!(id)
   # card_number = account_struct.card_number


    # cvv = String.slice(card_number, -3, 3)
    # expiration_date = BAC.Run.generate_expiration_date()
    # card_params = %{card_number: card_number, card_status: "Active", cvv: cvv, expiry_date: expiration_date}

    with {:ok, account_struct12} <- get_customer_struct_v2(id),
    {:ok, card_str} <- get_card_no(account_struct12),
    {:ok, new_cvv} <- gen_cvv(card_str),
    {:ok, new_exp} <- generate_expiration_date_now(),
    {:ok, params_card12 } <- IO.inspect(gen_new_card_params(card_str,new_exp,new_cvv)),
    {:ok, _job1} <- Oban.insert(BAC.Workers.CardActivationWorker.new(%{"account_struct" => account_struct12, "card_params" => params_card12})) do
   # {:ok, %Card{} = card} <- Accounts.create_card(account_struct, params_card) do

      IO.puts("Card activated")
    else
     {:error, reason} -> {:error, IO.inspect(reason)}
    end

  end

  def get_card_no(strc) do
    card_number = strc.card_number

    {:ok , card_number}
  end

  defp get_customer_v2(id), do: Repo.get(Account, id)

  def get_customer_struct_v2(id) do
    case get_customer_v2(id) do
      nil -> {:error, "This customer doesnt exist in our system."}
      account -> {:ok, account}
    end
  end

  def gen_cvv(card_no) do

    last_three_digits = String.slice(card_no, -3, 3)
    {:ok, last_three_digits}

  end

  def generate_expiration_date_now do
    current_year = Date.utc_today().year()
    random_month = Enum.random(1..12)
    random_year = current_year + Enum.random(1..5) # Generating a random year in the next 5 years

    month_string = String.pad_leading(Integer.to_string(random_month), 2, "0")
    year_string = Integer.to_string(random_year)

    # Extract the last two characters of the year string
    year_last_two_digits = String.slice(year_string, -2, 2)

    expiration_date = "#{month_string}/#{year_last_two_digits}"

    IO.puts("Generated Expiration Date: #{expiration_date}")

    {:ok,expiration_date}
  end

  def gen_new_card_params(card, exp, cvv) do
    card_params_new = %{"card_number" =>  card , "expiry_date" => exp , "cvv" => cvv }

    IO.puts("its lunch")
   {:ok, card_params_new }
  end

end
