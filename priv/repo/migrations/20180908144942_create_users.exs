defmodule Giver.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :nickname, :string
      add :is_active, :boolean, default: true, null: false
      add :telephone, :string
      add :email, :string
      add :gender, :integer, default: -1
      add :birthday, :naive_datetime
      add :avatar, :string
      add :password_hash, :string

      timestamps()
    end

  end
end
