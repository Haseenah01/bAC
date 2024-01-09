defmodule BACWeb.CustomerController do
  use BACWeb, :controller

  alias BAC.Customers
  alias BAC.Customers.Customer

  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    customers = Customers.list_customers()
    render(conn, :index, customers: customers)
  end

  def create(conn, %{"customer" => customer_params}) do
    IO.inspect(customer_params)
    with {:ok, _} <- Oban.insert(BAC.Workers.CreateCustomerWorker.new(%{"customer" => customer_params})) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/customers/#{customer}")
      |> render(:show11, customer: "customer")
    end
  end


  # def create(conn, %{"customer" => customer_params}) do
  #   with {:ok, %Customer{} = customer} <- Customers.create_customer(customer_params) do
  #     conn
  #     |> put_status(:created)
  #     # |> put_resp_header("location", ~p"/api/customers/#{customer}")
  #     |> render(:show, customer: customer)
  #   end
  # end
  def show(conn, %{"id" => id}) do
    customer = Customers.get_customer!(id)
    render(conn, :show, customer: customer)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Customers.get_customer!(id)

    with {:ok, %Customer{} = customer} <- Customers.update_customer(customer, customer_params) do
      render(conn, :show, customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Customers.get_customer!(id)

    with {:ok, %Customer{}} <- Customers.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end
