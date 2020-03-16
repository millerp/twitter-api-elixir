defmodule Twitter.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :follow_user_id, references(:users, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create unique_index(:follows, [:user_id, :follow_user_id])
  end
end
