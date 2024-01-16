defmodule BACWeb.CardController do
  use BACWeb, :controller

  alias BAC.Accounts
  alias BAC.Accounts.Card
  alias BAC.Customers.Customer
  alias BAC.Accounts.Account


  import Ecto.Query, warn: false
  alias BAC.Repo
  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    cards = Accounts.list_cards()
    render(conn, :index, cards: cards)
  end


  defp get_account_bank(id), do: Repo.get(Account, id)

  def get_me_account_struct(id) do
    case get_account_bank(id) do
      nil -> {:error, "Account doesnt exist in the system"}
      account -> {:ok,account}
    end
  end

  def get_card_number(card_number) do
    Card # our scema file
    |> where(card_number: ^card_number)
    # basically is for returning user data wtogether with account
    #|> preload([:customer]) # this bcs of the relationship between the two
    |> Repo.one()
  end

  #check length of card number if its right the regenate the new one

  # make a cvv

  # combine all the card params now


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
        {:ok,new_card_number}

      _existing_number ->
        # Account number already exists, generate a new one
        generate_card_number()
    end
  end


  def verify_card_number(card_number) do
    case get_card_number(card_number) do
      nil ->
        IO.puts("You can verify")
        {:ok,card_number}
       # {:ok, "You can verify"}
      card ->
        IO.puts("Generating new card number")
        generate_card_number()
       # {:error, "Already exist within the system"}
    end
  end

  def gen_cvv(card_no) do

    last_three_digits = String.slice(card_no, -3, 3)
    {:ok,last_three_digits}

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
   {:ok, card_params_new }
  end

  def activate_card(conn, %{"card_number" => card_number,"card" => card_params}) do

    # must provide customer id
    account_single = Map.get(card_params,"account_id")

    # Have to put this and do some pattern match
  # customer_struct = IO.inspect(get_customer_user(customer_single))

   # Verify that card number if exist on database

   # Verify if that account number has right number of length

   # Take last 3 digist and make it cvv

   # Have last function that will combine everything and make card params

    with {:ok, %Account{} = acc_str} <- get_me_account_struct(account_single),
      {:ok,new_card_num} <- verify_card_number(card_number),
      {:ok,new_cvv} <- gen_cvv(new_card_num),
      {:ok, new_exp} <- generate_expiration_date_now(),
      {:ok,params_card }<- gen_new_card_params(new_card_num,new_exp,new_cvv),
     {:ok, %Card{} = card} <- Accounts.create_card(acc_str,params_card) do
      conn
      |> put_status(:created)
      #|> put_resp_header("location", ~p"/api/cards/#{card}")
      |> render(:show, card: card)
    else
      {:error, reason} -> {:error, IO.inspect(reason)}
    end
  end


  def activate_card_v1(conn, %{"id" => id}) do

    IO.inspect(id)
    account_struct = BAC.Accounts.get_account!(id)
    IO.inspect(account_struct)
    card_number = account_struct.card_number
    IO.inspect(card_number)

    cvv = String.slice(card_number, -3, 3)
    expiration_date = BAC.Run.generate_expiration_date()
    card_params = %{card_number: card_number, card_status: "Active", cvv: cvv, expiry_date: expiration_date}

    with {:ok, job} <- Oban.insert(BAC.Workers.CardValidatorWorker.new(%{"id" => id})) do
    #{:ok, %Card{} = card} <- Accounts.create_card(account_struct, card_params) do
      IO.puts("Musanda")
    conn
      |> put_status(:created)
      |> render(:show11, card: "card")
     end

  end

  def create(conn, %{"card" => card_params}) do
    with {:ok, %Card{} = card} <- Accounts.create_card(card_params) do
      conn
      |> put_status(:created)
      #|> put_resp_header("location", ~p"/api/cards/#{card}")
      |> render(:show, card: card)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Accounts.get_card!(id)
    render(conn, :show, card: card)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Accounts.get_card!(id)

    with {:ok, %Card{} = card} <- Accounts.update_card(card, card_params) do
      render(conn, :show, card: card)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Accounts.get_card!(id)

    with {:ok, %Card{}} <- Accounts.delete_card(card) do
      send_resp(conn, :no_content, "")
    end
  end
end
