defmodule BAC.Repo.Migrations.CreateServiceActivationLogs do
  use Ecto.Migration

  def change do
    create table(:service_activation_logs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :activation_date, :date
      add :activation_type, :string
      add :details, :string
      add :customer_id, references(:customers, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create unique_index(:service_activation_logs, [:customer_id])
  end
end
