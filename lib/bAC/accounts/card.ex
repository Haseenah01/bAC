defmodule BAC.Accounts.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cards" do
    field :card_number, :string
    field :expiry_date, :date
    field :cvv, :string
    field :card_status, :string
    # field :account_id, :id
    belongs_to :account, BAC.Accounts.Account


    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:card_number, :expiry_date, :cvv, :card_status])
    # |> validate_required([:card_number, :expiry_date, :cvv, :card_status])
    |> unique_constraint([:card_number])
  end
end
