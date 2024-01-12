defmodule BACWeb.AccountController do
  use BACWeb, :controller

  alias BAC.Accounts
  alias BAC.Accounts.Account
  alias BAC.Accounts.Card

  import Ecto.Query, warn: false
  alias BAC.Repo

  alias BAC.Customers.Customer

  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  defp get_customer_user(id), do: Repo.get(Customer, id)

  def get_me_customer_struct(id) do
    case get_customer_user(id) do
      nil -> {:error, :not_found} # this works for the error response plug ehrn using it by other side
      customer -> customer
    end
  end



  defp generate_random_card_suffix_v2 do
    Integer.to_string(:rand.uniform(10_000_000_000_000))
    |> String.pad_leading(16, "0")
  end

  def generate_card_number_v2 do
    prefix = "6742"
    new_card_number = prefix <> generate_random_card_suffix_v2()
   # new_account_number = generate_random_number()
   new_card_number
    # case BAC.Repo.one(from(a in BAC.Accounts.Card, where: a.card_number == ^new_card_number)) do
    #   nil ->

    #     # Account number doesn't exist, insert into the database
    #    # BAC.Repo.insert!(%YourApp.Accounts{account_number: new_account_number})
    #     new_card_number

    #   _existing_number ->
    #     # Account number already exists, generate a new one
    #     generate_card_number()
    # end
  end
def create_v2(conn, %{"customer_id" => customer_id,"account" => account_params}) do

    IO.inspect(account_params)

new_key = "account_number"
new_value = BAC.Run.generate_account_number()
IO.inspect(new_value)

new_map = Map.put(account_params, new_key, new_value)

IO.inspect(new_map)


expiration_date = BAC.Run.generate_expiration_date()
card_no =  generate_card_number_v2()


last_three_digits = String.slice(card_no, -3, 3)

card_params = %{"card_number" =>  card_no , "expiry_date" => expiration_date , "cvv" => last_three_digits }

IO.inspect(card_params)
    customer_struct = IO.inspect(get_customer_user(customer_id))

    # {:ok, %Card{} = card} <- Accounts.create_card(account, card_params)
    with {:ok, %Account{} = account} <- Accounts.create_account(customer_struct,new_map) do
      conn
      |> put_status(:created)
      |> render(:show_acc_number, account: account, card_number: card_no)
    end
end

  def create(conn, %{"customer_id" => customer_id,"account" => account_params}) do

    # CHeck if customer exist or not

    # def get_me_id(id) do
    #   case Users.get_full_userhhh(id) do
    #     nil -> {:error, :unauthorized} # this works for the error response plug ehrn using it by other side
    #     customer -> customer.id
    #   end
    # end

    IO.inspect(account_params)



# Key-value pair to insert
new_key = "account_number"
new_value = BAC.Run.generate_account_number()
IO.inspect(new_value)

new_map = Map.put(account_params, new_key, new_value)

IO.inspect(new_map)

#     # Existing map
# existing_map = %{key1: "value1", key2: "value2"}

# # Key-value pairs to insert or update
# new_key_value_pairs = [key3: "value3", key4: "value4"]

# # Inserting or updating key-value pairs
# new_map = existing_map
#           |> Enum.reduce(new_key_value_pairs, &Map.put(&1, elem(&2, 0), elem(&2, 1)))

# IO.inspect(new_map)

# fUNCTIONALITY OF CARD

expiration_date = BAC.Run.generate_expiration_date()
card_no = BAC.Run.generate_card_number()


last_three_digits = String.slice(card_no, -3, 3)

card_params = %{"card_number" =>  card_no , "expiry_date" => expiration_date , "cvv" => last_three_digits }

IO.inspect(card_params)
    customer_struct = IO.inspect(get_customer_user(customer_id))

    # {:ok, %Card{} = card} <- Accounts.create_card(account, card_params)
    with {:ok, %Account{} = account} <- Accounts.create_account(customer_struct,new_map),
    {:ok, %Card{} = card} <- Accounts.create_card(account, card_params)  do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/accounts/#{account}")
      |> render(:show, account: account)
    end
  end



  # def create(conn, %{"account" => account_params}) do
  #   with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/accounts/#{account}")
  #     |> render(:show, account: account)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
