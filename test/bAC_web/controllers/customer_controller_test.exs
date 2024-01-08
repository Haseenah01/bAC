defmodule BACWeb.CustomerControllerTest do
  use BACWeb.ConnCase

  import BAC.CustomersFixtures

  alias BAC.Customers.Customer

  @create_attrs %{
    status: "some status",
    email: "some email",
    firstName: "some firstName",
    lastName: "some lastName",
    phoneNumber: "some phoneNumber",
    dateOfBirth: ~D[2024-01-07],
    idNumber: "some idNumber"
  }
  @update_attrs %{
    status: "some updated status",
    email: "some updated email",
    firstName: "some updated firstName",
    lastName: "some updated lastName",
    phoneNumber: "some updated phoneNumber",
    dateOfBirth: ~D[2024-01-08],
    idNumber: "some updated idNumber"
  }
  @invalid_attrs %{status: nil, email: nil, firstName: nil, lastName: nil, phoneNumber: nil, dateOfBirth: nil, idNumber: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all customers", %{conn: conn} do
      conn = get(conn, ~p"/api/customers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create customer" do
    test "renders customer when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/customers", customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/customers/#{id}")

      assert %{
               "id" => ^id,
               "dateOfBirth" => "2024-01-07",
               "email" => "some email",
               "firstName" => "some firstName",
               "idNumber" => "some idNumber",
               "lastName" => "some lastName",
               "phoneNumber" => "some phoneNumber",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/customers", customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update customer" do
    setup [:create_customer]

    test "renders customer when data is valid", %{conn: conn, customer: %Customer{id: id} = customer} do
      conn = put(conn, ~p"/api/customers/#{customer}", customer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/customers/#{id}")

      assert %{
               "id" => ^id,
               "dateOfBirth" => "2024-01-08",
               "email" => "some updated email",
               "firstName" => "some updated firstName",
               "idNumber" => "some updated idNumber",
               "lastName" => "some updated lastName",
               "phoneNumber" => "some updated phoneNumber",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, customer: customer} do
      conn = put(conn, ~p"/api/customers/#{customer}", customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete customer" do
    setup [:create_customer]

    test "deletes chosen customer", %{conn: conn, customer: customer} do
      conn = delete(conn, ~p"/api/customers/#{customer}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/customers/#{customer}")
      end
    end
  end

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end
end
