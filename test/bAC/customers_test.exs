defmodule BAC.CustomersTest do
  use BAC.DataCase

  alias BAC.Customers

  describe "customers" do
    alias BAC.Customers.Customer

    import BAC.CustomersFixtures

    @invalid_attrs %{status: nil, email: nil, firstName: nil, lastName: nil, phoneNumber: nil, dateOfBirth: nil, idNumber: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Customers.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{status: "some status", email: "some email", firstName: "some firstName", lastName: "some lastName", phoneNumber: "some phoneNumber", dateOfBirth: ~D[2024-01-07], idNumber: "some idNumber"}

      assert {:ok, %Customer{} = customer} = Customers.create_customer(valid_attrs)
      assert customer.status == "some status"
      assert customer.email == "some email"
      assert customer.firstName == "some firstName"
      assert customer.lastName == "some lastName"
      assert customer.phoneNumber == "some phoneNumber"
      assert customer.dateOfBirth == ~D[2024-01-07]
      assert customer.idNumber == "some idNumber"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{status: "some updated status", email: "some updated email", firstName: "some updated firstName", lastName: "some updated lastName", phoneNumber: "some updated phoneNumber", dateOfBirth: ~D[2024-01-08], idNumber: "some updated idNumber"}

      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, update_attrs)
      assert customer.status == "some updated status"
      assert customer.email == "some updated email"
      assert customer.firstName == "some updated firstName"
      assert customer.lastName == "some updated lastName"
      assert customer.phoneNumber == "some updated phoneNumber"
      assert customer.dateOfBirth == ~D[2024-01-08]
      assert customer.idNumber == "some updated idNumber"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
