defmodule BACWeb.CustomerController do
  use BACWeb, :controller

  alias BAC.Customers
  alias BAC.Customers.Customer

  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    customers = Customers.list_customers()
    render(conn, :index, customers: customers)
  end

  # def create(conn, %{"customer" => customer_params}) do

  #   with {:ok, customer_par} <- Oban.insert(BAC.Workers.CreateCustomerWorker.new(%{"customer" => customer_params})) do
  #     Logger.info(customer_par)
  #     conn
  #     |> put_status(:created)
  #     # |> put_resp_header("location", ~p"/api/customers/#{customer}")
  #     |> render(:show11, customer: "customer")
  #   end
  # end

  def test_work(customer_params) do
    {:ok, job} = Oban.insert(BAC.Workers.CustomerValidatorWorker.new(%{"customer" => customer_params}))
  end

  def create(conn, %{"customer" => customer_params}) do


    # relay =
    #   %{id: 123}
    #   |> MyApp.Worker.new()
    #   |> Oban.Pro.Relay.async()


    # {:ok, result} =
    #   %{id: 123}
    #   |> MyApp.Worker.new()
    #   |> Oban.Pro.Relay.async()
    #   |> Oban.Pro.Relay.await()

    #   {:ok, result} = Oban.Pro.Relay.await(relay, :timer.seconds(30))

    # job_id1 = 1
    #with {:ok, customer} <- Oban.insert(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})) do
    with {:ok, customer} <- Oban.Pro.Relay.await(Oban.Pro.Relay.async(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})), :timer.seconds(30)) do
        Logger.info("CustomerValidatorWorker enqueued successfully")
          conn
          |> put_status(:created)
          |> render(:show, customer: customer)
    else
      {:error, reason} ->
        Logger.info("CustomerValidatorWorker enqueue failed: #{reason}")
    end

     # Enqueue CustomerValidatorWorker
    #  case test_work(customer_params) do
    #   {:ok, job} ->
    #     Logger.info(job)
    #     Logger.info("Enqueue CreateCustomerV2Worker")
    #     conn
    #         |> put_status(:created)
    #         |> render(:show11, customer: "customer")
    #     # case Oban.insert(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})) do
    #     #   {:ok, _} ->
    #     #     # Your remaining controller logic
    #     #     conn
    #     #     |> put_status(:created)
    #     #     |> render(:show11, customer: "customer")

    #     #   {:error, reason} ->
    #     #     Logger.info("CreateCustomerV2Worker enqueue failed: #{reason}")
    #     #     # conn
    #     #     # |> put_status(:internal_server_error)
    #     #     # |> render("error_template.html")
    #     # end

    #   {:error, reason} ->
    #     Logger.info("CustomerValidatorWorker enqueue failed: #{reason}")
    # end

    #with {:ok, customer_par} <- Oban.insert(BAC.Workers.CustomerValidatorWorker.new(%{"customer" => customer_params})),
    # with {:ok, _customer_par} <- Oban.insert(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})) do
    #      conn
    #     |> put_status(:created)
    #     # |> put_resp_header("location", ~p"/api/customers/#{customer}")
    #     |> render(:show11, customer: "customer")
    # else
    #   {:error, reason} -> {:error, Logger.info(reason)}
    # end
  end


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
