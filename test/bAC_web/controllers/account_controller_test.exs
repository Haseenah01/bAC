defmodule BACWeb.AccountControllerTest do
  use BACWeb.ConnCase

  import BAC.AccountsFixtures

  alias BAC.Accounts.Account

  @create_attrs %{
    balance: 120.5,
    account_type: "some account_type",
    account_number: "some account_number",
    account_status: "some account_status",
    open_date: ~D[2024-01-08]
  }
  @update_attrs %{
    balance: 456.7,
    account_type: "some updated account_type",
    account_number: "some updated account_number",
    account_status: "some updated account_status",
    open_date: ~D[2024-01-09]
  }
  @invalid_attrs %{balance: nil, account_type: nil, account_number: nil, account_status: nil, open_date: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/accounts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "account_number" => "some account_number",
               "account_status" => "some account_status",
               "account_type" => "some account_type",
               "balance" => 120.5,
               "open_date" => "2024-01-08"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "account_number" => "some updated account_number",
               "account_status" => "some updated account_status",
               "account_type" => "some updated account_type",
               "balance" => 456.7,
               "open_date" => "2024-01-09"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, ~p"/api/accounts/#{account}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/accounts/#{account}")
      end
    end
  end

  defp create_account(_) do
    account = account_fixture()
    %{account: account}
  end
end
