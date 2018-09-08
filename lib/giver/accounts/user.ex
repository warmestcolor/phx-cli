defmodule Giver.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :username, :string
    field :avatar, :string
    field :birthday, :naive_datetime
    field :email, :string
    field :gender, :integer, default: -1
    field :is_active, :boolean, default: true
    field :nickname, :string
    field :telephone, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :is_active, :telephone, :email, :gender, :birthday, :avatar])
    |> validate_required([:nickname, :avatar])
    # |> unique_constraint(:nickname)
    |> put_password_hash()
  end

  defp put_password_hash(
      %Ecto.Changeset{
        valid?: true, changes: %{password: password}
      } = changeset
    ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
