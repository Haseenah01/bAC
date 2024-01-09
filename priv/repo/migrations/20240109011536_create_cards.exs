defmodule BAC.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :card_number, :string
      add :expiry_date, :date
      add :cvv, :string
      add :card_status, :string, default: "NotActivated", null: false
      add :account_id, references(:accounts, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create unique_index(:cards, [:account_id, :card_number, :cvv])
  end
end
