defmodule BAC.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BAC.Customers` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        dateOfBirth: ~D[2024-01-07],
        email: "some email",
        firstName: "some firstName",
        idNumber: "some idNumber",
        lastName: "some lastName",
        phoneNumber: "some phoneNumber",
        status: "some status"
      })
      |> BAC.Customers.create_customer()

    customer
  end
end
