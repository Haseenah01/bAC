defmodule BAC.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :firstName, :string
      add :lastName, :string
      add :phoneNumber, :string
      add :dateOfBirth, :date
      add :idNumber, :string
      add :email, :string
      add :status, :string

      timestamps()
    end
  end
end
