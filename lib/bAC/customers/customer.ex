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

    has_many :account, BAC.Accounts.Account
    has_many :service_activation_log, BAC.Accounts.ServiceActivationLog

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:firstName, :lastName, :phoneNumber, :dateOfBirth, :idNumber, :email, :status])
    |> validate_required([:firstName, :lastName, :phoneNumber, :dateOfBirth, :idNumber, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces") # email validation
    |> validate_length(:email, max: 100) # 100 chracters
    |> unique_constraint(:email) # making our email to be unique
    |> unique_constraint(:idNumber, is: 13) # making our email to be unique
    |> unique_constraint([:phoneNumber]) # making our email to be unique
  end
end
