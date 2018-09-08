defmodule Giver.Accounts.Authentication do
  use Ecto.Schema
  import Ecto.Changeset

  alias Giver.Accounts.User

  schema "authentications" do
    field :avatar, :string
    field :email, :string
    field :name, :string
    field :gender, :integer, default: -1
    field :nickname, :string
    field :platform, :string
    field :refresh_token, :string
    field :telephone, :string
    field :token, :string
    field :token_secret, :string
    field :uid, :string
    field :union_id, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(authentication, attrs) do
    authentication
    |> cast(attrs, [:user_id, :email, :telephone, :avatar, :nickname, :gender, :platform, :token, :refresh_token, :token_secret, :uid, :union_id])
    |> validate_required([:avatar, :nickname, :platform, :uid])
  end
end
