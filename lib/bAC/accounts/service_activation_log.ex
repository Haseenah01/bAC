defmodule BAC.Accounts.ServiceActivationLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "service_activation_logs" do
    field :activation_date, :date
    field :activation_type, :string
    field :details, :string
    # field :customer_id, :id
    belongs_to :customer, BAC.Customers.Customer

    timestamps()
  end

  @doc false
  def changeset(service_activation_log, attrs) do
    service_activation_log
    |> cast(attrs, [:activation_date, :activation_type, :details])
    |> validate_required([:activation_date, :activation_type, :details])
  end
end
