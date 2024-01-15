defmodule BACWeb.AccountController do
  use BACWeb, :controller

  alias BAC.Accounts
  alias BAC.Accounts.Account

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
      nil -> {:error, :not_found} # this works for the error response plug
      customer -> customer
    end
  end



  def generate_random_card_suffix_v2 do
    Integer.to_string(:rand.uniform(10_000_000_000_000))
    |> String.pad_leading(16, "0")
  end

  def generate_card_number_v2 do
    prefix = "6742"
    new_card_number = prefix <> generate_random_card_suffix_v2()

   new_card_number

  end
def create_v2(conn, %{"customer_id" => customer_id,"account" => account_params}) do

      new_key = "account_number"
      new_value = BAC.Run.generate_account_number()
      new_map = Map.put(account_params, new_key, new_value)

      #
      card_no =  generate_card_number_v2()
      account_map = Map.put(new_map, "card_number", card_no)



      customer_struct = IO.inspect(get_customer_user(customer_id))

    with {:ok, %Account{} = account} <- Accounts.create_account(customer_struct, account_map) do
      conn
      |> put_status(:created)
      |> render(:show_acc_number, account: account)
    end
end

#


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
