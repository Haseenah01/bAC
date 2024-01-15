defmodule BACWeb.ServiceActivationLogController do
  use BACWeb, :controller

  alias BAC.Accounts
  alias BAC.Accounts.ServiceActivationLog

  action_fallback BACWeb.FallbackController

  def index(conn, _params) do
    service_activation_logs = Accounts.list_service_activation_logs()
    render(conn, :index, service_activation_logs: service_activation_logs)
  end

  def create(conn, %{"service_activation_log" => service_activation_log_params}) do
    with {:ok, %ServiceActivationLog{} = service_activation_log} <- Accounts.create_service_activation_log(service_activation_log_params) do
      conn
      |> put_status(:created)
      |> render(:show, service_activation_log: service_activation_log)
    end
  end

  def show(conn, %{"id" => id}) do
    service_activation_log = Accounts.get_service_activation_log!(id)
    render(conn, :show, service_activation_log: service_activation_log)
  end

  def update(conn, %{"id" => id, "service_activation_log" => service_activation_log_params}) do
    service_activation_log = Accounts.get_service_activation_log!(id)

    with {:ok, %ServiceActivationLog{} = service_activation_log} <- Accounts.update_service_activation_log(service_activation_log, service_activation_log_params) do
      render(conn, :show, service_activation_log: service_activation_log)
    end
  end

  def delete(conn, %{"id" => id}) do
    service_activation_log = Accounts.get_service_activation_log!(id)

    with {:ok, %ServiceActivationLog{}} <- Accounts.delete_service_activation_log(service_activation_log) do
      send_resp(conn, :no_content, "")
    end
  end
end
