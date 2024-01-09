defmodule BAC.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BAC.Repo

  alias BAC.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  alias BAC.Accounts.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end

  alias BAC.Accounts.ServiceActivationLog

  @doc """
  Returns the list of service_activation_logs.

  ## Examples

      iex> list_service_activation_logs()
      [%ServiceActivationLog{}, ...]

  """
  def list_service_activation_logs do
    Repo.all(ServiceActivationLog)
  end

  @doc """
  Gets a single service_activation_log.

  Raises `Ecto.NoResultsError` if the Service activation log does not exist.

  ## Examples

      iex> get_service_activation_log!(123)
      %ServiceActivationLog{}

      iex> get_service_activation_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service_activation_log!(id), do: Repo.get!(ServiceActivationLog, id)

  @doc """
  Creates a service_activation_log.

  ## Examples

      iex> create_service_activation_log(%{field: value})
      {:ok, %ServiceActivationLog{}}

      iex> create_service_activation_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service_activation_log(attrs \\ %{}) do
    %ServiceActivationLog{}
    |> ServiceActivationLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service_activation_log.

  ## Examples

      iex> update_service_activation_log(service_activation_log, %{field: new_value})
      {:ok, %ServiceActivationLog{}}

      iex> update_service_activation_log(service_activation_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service_activation_log(%ServiceActivationLog{} = service_activation_log, attrs) do
    service_activation_log
    |> ServiceActivationLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a service_activation_log.

  ## Examples

      iex> delete_service_activation_log(service_activation_log)
      {:ok, %ServiceActivationLog{}}

      iex> delete_service_activation_log(service_activation_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service_activation_log(%ServiceActivationLog{} = service_activation_log) do
    Repo.delete(service_activation_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service_activation_log changes.

  ## Examples

      iex> change_service_activation_log(service_activation_log)
      %Ecto.Changeset{data: %ServiceActivationLog{}}

  """
  def change_service_activation_log(%ServiceActivationLog{} = service_activation_log, attrs \\ %{}) do
    ServiceActivationLog.changeset(service_activation_log, attrs)
  end
end
