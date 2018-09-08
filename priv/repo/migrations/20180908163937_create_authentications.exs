defmodule Giver.Repo.Migrations.CreateAuthentications do
  use Ecto.Migration

  def change do
    create table(:authentications) do
      add :email, :string
      add :telephone, :string
      add :avatar, :string
      add :name, :string
      add :gender, :integer, default: -1 # unset
      add :nickname, :string
      add :platform, :string
      add :token, :string
      add :refresh_token, :string
      add :token_secret, :string
      add :uid, :string
      add :union_id, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:authentications, [:user_id])
  end
end
