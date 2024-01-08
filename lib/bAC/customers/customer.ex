defmodule BAC.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :status, :string
    field :email, :string
    field :firstName, :string
    field :lastName, :string
    field :phoneNumber, :string
    field :dateOfBirth, :date
    field :idNumber, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:firstName, :lastName, :phoneNumber, :dateOfBirth, :idNumber, :email, :status])
    |> validate_required([:firstName, :lastName, :phoneNumber, :dateOfBirth, :idNumber, :email, :status])
  end
end
