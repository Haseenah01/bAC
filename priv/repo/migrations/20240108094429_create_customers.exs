defmodule BAC.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :firstName, :string
      add :lastName, :string
      add :phoneNumber, :string
      add :dateOfBirth, :date
      add :idNumber, :string
      add :email, :string
      add :status, :string, default: "InActive", null: false

      timestamps()
    end

    create unique_index(:customers, [:email,:idNumber,:phoneNumber])
  end
end
