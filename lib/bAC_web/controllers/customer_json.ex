defmodule BACWeb.CustomerJSON do
  alias BAC.Customers.Customer

  @doc """
  Renders a list of customers.
  """
  def index(%{customers: customers}) do
    %{data: for(customer <- customers, do: data(customer))}
  end

  @doc """
  Renders a single customer.
  """
  def show(%{customer: customer}) do
    %{data: data(customer)}
  end

  def show_data(%{customer: "customer"}) do
    %{customer: "customer"}
  end

  defp data(%Customer{} = customer) do
    %{
      id: customer.id,
      firstName: customer.firstName,
      lastName: customer.lastName,
      phoneNumber: customer.phoneNumber,
      dateOfBirth: customer.dateOfBirth,
      idNumber: customer.idNumber,
      email: customer.email,
      status: customer.status
    }
  end
end
