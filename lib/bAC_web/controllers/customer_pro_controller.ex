defmodule BACWeb.CustomerProController do
  use BACWeb, :controller

  alias BAC.Customers
  alias BAC.Customers.Customer

  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    customers = Customers.list_customers()
    render(conn, :index, customers: customers)
  end

  def create_pro(conn, %{"customer" => customer_params}) do


#  BAC.Workers.CustomerValidatorWorkerPro.new_workflow()
# |> BAC.Workers.CustomerValidatorWorkerPro.add(:a,  BAC.Workers.CustomerValidatorWorkerPro.new(%{"customer" => customer_params}))
# |> BAC.Workers.CustomerValidatorWorkerPro.add(:b, BAC.Workers.CreateCustomerV2WorkerPro.new(%{"customer" => customer_params}), deps: [:a])
# |> BAC.Workers.CustomerValidatorWorkerPro.add(:c, BAC.Workers.EmailjobPro1.new(%{"customer" => customer_params}), deps: [:b])
# |> Oban.insert_all()


# |> WorkerB.add(:d, WorkerB.new(%{url: "getoban.pro"}), deps: [:a])
# |> WorkerC.add(:e, WorkerC.new(%{}), deps: [:b, :c, :d])
    with {:ok, customer} <- Oban.Pro.Relay.await(Oban.Pro.Relay.async(BAC.Workers.CreateCustomerV2Worker.new(%{"customer" => customer_params})), :timer.seconds(30)) do
      IO.puts("CustomerValidatorWorker enqueued successfully")
        conn
        |> put_status(:created)
        |> render(:show, customer: customer)
  else
    {:error, reason} ->
      IO.puts("CustomerValidatorWorker enqueue failed: #{reason}")
  end

  end

end
