defmodule Twitter.Repo.Migrations.CreateBlockedUsers do
  use Ecto.Migration

  def change do
    create table(:blocked_users) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :blocked_user_id, references(:users, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create unique_index(:blocked_users, [:user_id, :blocked_user_id])
  end
end
