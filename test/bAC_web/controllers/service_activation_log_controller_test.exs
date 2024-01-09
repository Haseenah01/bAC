defmodule BACWeb.ServiceActivationLogControllerTest do
  use BACWeb.ConnCase

  import BAC.AccountsFixtures

  alias BAC.Accounts.ServiceActivationLog

  @create_attrs %{
    activation_date: ~D[2024-01-08],
    activation_type: "some activation_type",
    details: "some details"
  }
  @update_attrs %{
    activation_date: ~D[2024-01-09],
    activation_type: "some updated activation_type",
    details: "some updated details"
  }
  @invalid_attrs %{activation_date: nil, activation_type: nil, details: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all service_activation_logs", %{conn: conn} do
      conn = get(conn, ~p"/api/service_activation_logs")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create service_activation_log" do
    test "renders service_activation_log when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/service_activation_logs", service_activation_log: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/service_activation_logs/#{id}")

      assert %{
               "id" => ^id,
               "activation_date" => "2024-01-08",
               "activation_type" => "some activation_type",
               "details" => "some details"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/service_activation_logs", service_activation_log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update service_activation_log" do
    setup [:create_service_activation_log]

    test "renders service_activation_log when data is valid", %{conn: conn, service_activation_log: %ServiceActivationLog{id: id} = service_activation_log} do
      conn = put(conn, ~p"/api/service_activation_logs/#{service_activation_log}", service_activation_log: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/service_activation_logs/#{id}")

      assert %{
               "id" => ^id,
               "activation_date" => "2024-01-09",
               "activation_type" => "some updated activation_type",
               "details" => "some updated details"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, service_activation_log: service_activation_log} do
      conn = put(conn, ~p"/api/service_activation_logs/#{service_activation_log}", service_activation_log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete service_activation_log" do
    setup [:create_service_activation_log]

    test "deletes chosen service_activation_log", %{conn: conn, service_activation_log: service_activation_log} do
      conn = delete(conn, ~p"/api/service_activation_logs/#{service_activation_log}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/service_activation_logs/#{service_activation_log}")
      end
    end
  end

  defp create_service_activation_log(_) do
    service_activation_log = service_activation_log_fixture()
    %{service_activation_log: service_activation_log}
  end
end
