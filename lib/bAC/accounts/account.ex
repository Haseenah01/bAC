defmodule BAC.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias BAC.Customers.Customer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :float
    field :account_type, :string
    field :account_number, :string
    field :card_number, :string
    field :account_status, :string
    field :open_date, :date
    # field :customer_id, :id
    belongs_to :customer, BAC.Customers.Customer
    has_many :card, BAC.Accounts.Card

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_type, :account_number, :account_status, :balance, :open_date, :card_number])
    |> validate_required([:account_type, :balance])
    # |> unique_constraint(:account_number)
  end
end