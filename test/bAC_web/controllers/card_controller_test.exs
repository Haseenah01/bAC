defmodule BACWeb.CardControllerTest do
  use BACWeb.ConnCase

  import BAC.AccountsFixtures

  alias BAC.Accounts.Card

  @create_attrs %{
    card_number: "some card_number",
    expiry_date: ~D[2024-01-08],
    cvv: "some cvv",
    card_status: "some card_status"
  }
  @update_attrs %{
    card_number: "some updated card_number",
    expiry_date: ~D[2024-01-09],
    cvv: "some updated cvv",
    card_status: "some updated card_status"
  }
  @invalid_attrs %{card_number: nil, expiry_date: nil, cvv: nil, card_status: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all cards", %{conn: conn} do
      conn = get(conn, ~p"/api/cards")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create card" do
    test "renders card when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/cards", card: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/cards/#{id}")

      assert %{
               "id" => ^id,
               "card_number" => "some card_number",
               "card_status" => "some card_status",
               "cvv" => "some cvv",
               "expiry_date" => "2024-01-08"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/cards", card: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update card" do
    setup [:create_card]

    test "renders card when data is valid", %{conn: conn, card: %Card{id: id} = card} do
      conn = put(conn, ~p"/api/cards/#{card}", card: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/cards/#{id}")

      assert %{
               "id" => ^id,
               "card_number" => "some updated card_number",
               "card_status" => "some updated card_status",
               "cvv" => "some updated cvv",
               "expiry_date" => "2024-01-09"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, card: card} do
      conn = put(conn, ~p"/api/cards/#{card}", card: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete card" do
    setup [:create_card]

    test "deletes chosen card", %{conn: conn, card: card} do
      conn = delete(conn, ~p"/api/cards/#{card}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/cards/#{card}")
      end
    end
  end

  defp create_card(_) do
    card = card_fixture()
    %{card: card}
  end
end
