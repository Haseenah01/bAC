defmodule BAC.AccountsTest do
  use BAC.DataCase

  alias BAC.Accounts

  describe "accounts" do
    alias BAC.Accounts.Account

    import BAC.AccountsFixtures

    @invalid_attrs %{balance: nil, account_type: nil, account_number: nil, account_status: nil, open_date: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{balance: 120.5, account_type: "some account_type", account_number: "some account_number", account_status: "some account_status", open_date: ~D[2024-01-08]}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.balance == 120.5
      assert account.account_type == "some account_type"
      assert account.account_number == "some account_number"
      assert account.account_status == "some account_status"
      assert account.open_date == ~D[2024-01-08]
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{balance: 456.7, account_type: "some updated account_type", account_number: "some updated account_number", account_status: "some updated account_status", open_date: ~D[2024-01-09]}

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.balance == 456.7
      assert account.account_type == "some updated account_type"
      assert account.account_number == "some updated account_number"
      assert account.account_status == "some updated account_status"
      assert account.open_date == ~D[2024-01-09]
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "cards" do
    alias BAC.Accounts.Card

    import BAC.AccountsFixtures

    @invalid_attrs %{card_number: nil, expiry_date: nil, cvv: nil, card_status: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Accounts.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Accounts.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{card_number: "some card_number", expiry_date: ~D[2024-01-08], cvv: "some cvv", card_status: "some card_status"}

      assert {:ok, %Card{} = card} = Accounts.create_card(valid_attrs)
      assert card.card_number == "some card_number"
      assert card.expiry_date == ~D[2024-01-08]
      assert card.cvv == "some cvv"
      assert card.card_status == "some card_status"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      update_attrs = %{card_number: "some updated card_number", expiry_date: ~D[2024-01-09], cvv: "some updated cvv", card_status: "some updated card_status"}

      assert {:ok, %Card{} = card} = Accounts.update_card(card, update_attrs)
      assert card.card_number == "some updated card_number"
      assert card.expiry_date == ~D[2024-01-09]
      assert card.cvv == "some updated cvv"
      assert card.card_status == "some updated card_status"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_card(card, @invalid_attrs)
      assert card == Accounts.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Accounts.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Accounts.change_card(card)
    end
  end

  describe "service_activation_logs" do
    alias BAC.Accounts.ServiceActivationLog

    import BAC.AccountsFixtures

    @invalid_attrs %{activation_date: nil, activation_type: nil, details: nil}

    test "list_service_activation_logs/0 returns all service_activation_logs" do
      service_activation_log = service_activation_log_fixture()
      assert Accounts.list_service_activation_logs() == [service_activation_log]
    end

    test "get_service_activation_log!/1 returns the service_activation_log with given id" do
      service_activation_log = service_activation_log_fixture()
      assert Accounts.get_service_activation_log!(service_activation_log.id) == service_activation_log
    end

    test "create_service_activation_log/1 with valid data creates a service_activation_log" do
      valid_attrs = %{activation_date: ~D[2024-01-08], activation_type: "some activation_type", details: "some details"}

      assert {:ok, %ServiceActivationLog{} = service_activation_log} = Accounts.create_service_activation_log(valid_attrs)
      assert service_activation_log.activation_date == ~D[2024-01-08]
      assert service_activation_log.activation_type == "some activation_type"
      assert service_activation_log.details == "some details"
    end

    test "create_service_activation_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_service_activation_log(@invalid_attrs)
    end

    test "update_service_activation_log/2 with valid data updates the service_activation_log" do
      service_activation_log = service_activation_log_fixture()
      update_attrs = %{activation_date: ~D[2024-01-09], activation_type: "some updated activation_type", details: "some updated details"}

      assert {:ok, %ServiceActivationLog{} = service_activation_log} = Accounts.update_service_activation_log(service_activation_log, update_attrs)
      assert service_activation_log.activation_date == ~D[2024-01-09]
      assert service_activation_log.activation_type == "some updated activation_type"
      assert service_activation_log.details == "some updated details"
    end

    test "update_service_activation_log/2 with invalid data returns error changeset" do
      service_activation_log = service_activation_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_service_activation_log(service_activation_log, @invalid_attrs)
      assert service_activation_log == Accounts.get_service_activation_log!(service_activation_log.id)
    end

    test "delete_service_activation_log/1 deletes the service_activation_log" do
      service_activation_log = service_activation_log_fixture()
      assert {:ok, %ServiceActivationLog{}} = Accounts.delete_service_activation_log(service_activation_log)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_service_activation_log!(service_activation_log.id) end
    end

    test "change_service_activation_log/1 returns a service_activation_log changeset" do
      service_activation_log = service_activation_log_fixture()
      assert %Ecto.Changeset{} = Accounts.change_service_activation_log(service_activation_log)
    end
  end
end
