defmodule Twitter.Repo.Migrations.Likes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :tweet_id, references(:tweets, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create unique_index(:likes, [:user_id, :tweet_id])
  end
end
