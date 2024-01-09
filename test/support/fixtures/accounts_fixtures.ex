defmodule BAC.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BAC.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        account_number: "some account_number",
        account_status: "some account_status",
        account_type: "some account_type",
        balance: 120.5,
        open_date: ~D[2024-01-08]
      })
      |> BAC.Accounts.create_account()

    account
  end

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        card_number: "some card_number",
        card_status: "some card_status",
        cvv: "some cvv",
        expiry_date: ~D[2024-01-08]
      })
      |> BAC.Accounts.create_card()

    card
  end

  @doc """
  Generate a service_activation_log.
  """
  def service_activation_log_fixture(attrs \\ %{}) do
    {:ok, service_activation_log} =
      attrs
      |> Enum.into(%{
        activation_date: ~D[2024-01-08],
        activation_type: "some activation_type",
        details: "some details"
      })
      |> BAC.Accounts.create_service_activation_log()

    service_activation_log
  end
end
