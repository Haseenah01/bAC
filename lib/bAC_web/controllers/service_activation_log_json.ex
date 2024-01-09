defmodule BACWeb.ServiceActivationLogJSON do
  alias BAC.Accounts.ServiceActivationLog

  @doc """
  Renders a list of service_activation_logs.
  """
  def index(%{service_activation_logs: service_activation_logs}) do
    %{data: for(service_activation_log <- service_activation_logs, do: data(service_activation_log))}
  end

  @doc """
  Renders a single service_activation_log.
  """
  def show(%{service_activation_log: service_activation_log}) do
    %{data: data(service_activation_log)}
  end

  defp data(%ServiceActivationLog{} = service_activation_log) do
    %{
      id: service_activation_log.id,
      activation_date: service_activation_log.activation_date,
      activation_type: service_activation_log.activation_type,
      details: service_activation_log.details
    }
  end
end
