defmodule Giver.AccountsTest do
  use Giver.DataCase

  alias Giver.Accounts

  describe "users" do
    alias Giver.Accounts.User

    @valid_attrs %{avatar: "some avatar", birthday: ~N[2010-04-17 14:00:00.000000], email: "some email", gender: 42, is_active: true, nickname: "some nickname", telphone: "some telphone", username: "some username"}
    @update_attrs %{avatar: "some updated avatar", birthday: ~N[2011-05-18 15:01:01.000000], email: "some updated email", gender: 43, is_active: false, nickname: "some updated nickname", telphone: "some updated telphone", username: "some updated username"}
    @invalid_attrs %{avatar: nil, birthday: nil, email: nil, gender: nil, is_active: nil, nickname: nil, telphone: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar == "some avatar"
      assert user.birthday == ~N[2010-04-17 14:00:00.000000]
      assert user.email == "some email"
      assert user.gender == 42
      assert user.is_active == true
      assert user.nickname == "some nickname"
      assert user.telphone == "some telphone"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar == "some updated avatar"
      assert user.birthday == ~N[2011-05-18 15:01:01.000000]
      assert user.email == "some updated email"
      assert user.gender == 43
      assert user.is_active == false
      assert user.nickname == "some updated nickname"
      assert user.telphone == "some updated telphone"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authentications" do
    alias Giver.Accounts.Authentication

    @valid_attrs %{avatar: "some avatar", email: "some email", nickname: "some nickname", platform: "some platform", refresh_token: "some refresh_token", telphone: "some telphone", token: "some token", token_secret: "some token_secret", uid: "some uid", union_id: "some union_id"}
    @update_attrs %{avatar: "some updated avatar", email: "some updated email", nickname: "some updated nickname", platform: "some updated platform", refresh_token: "some updated refresh_token", telphone: "some updated telphone", token: "some updated token", token_secret: "some updated token_secret", uid: "some updated uid", union_id: "some updated union_id"}
    @invalid_attrs %{avatar: nil, email: nil, nickname: nil, platform: nil, refresh_token: nil, telphone: nil, token: nil, token_secret: nil, uid: nil, union_id: nil}

    def authentication_fixture(attrs \\ %{}) do
      {:ok, authentication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_authentication()

      authentication
    end

    test "list_authentications/0 returns all authentications" do
      authentication = authentication_fixture()
      assert Accounts.list_authentications() == [authentication]
    end

    test "get_authentication!/1 returns the authentication with given id" do
      authentication = authentication_fixture()
      assert Accounts.get_authentication!(authentication.id) == authentication
    end

    test "create_authentication/1 with valid data creates a authentication" do
      assert {:ok, %Authentication{} = authentication} = Accounts.create_authentication(@valid_attrs)
      assert authentication.avatar == "some avatar"
      assert authentication.email == "some email"
      assert authentication.nickname == "some nickname"
      assert authentication.platform == "some platform"
      assert authentication.refresh_token == "some refresh_token"
      assert authentication.telphone == "some telphone"
      assert authentication.token == "some token"
      assert authentication.token_secret == "some token_secret"
      assert authentication.uid == "some uid"
      assert authentication.union_id == "some union_id"
    end

    test "create_authentication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_authentication(@invalid_attrs)
    end

    test "update_authentication/2 with valid data updates the authentication" do
      authentication = authentication_fixture()
      assert {:ok, authentication} = Accounts.update_authentication(authentication, @update_attrs)
      assert %Authentication{} = authentication
      assert authentication.avatar == "some updated avatar"
      assert authentication.email == "some updated email"
      assert authentication.nickname == "some updated nickname"
      assert authentication.platform == "some updated platform"
      assert authentication.refresh_token == "some updated refresh_token"
      assert authentication.telphone == "some updated telphone"
      assert authentication.token == "some updated token"
      assert authentication.token_secret == "some updated token_secret"
      assert authentication.uid == "some updated uid"
      assert authentication.union_id == "some updated union_id"
    end

    test "update_authentication/2 with invalid data returns error changeset" do
      authentication = authentication_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_authentication(authentication, @invalid_attrs)
      assert authentication == Accounts.get_authentication!(authentication.id)
    end

    test "delete_authentication/1 deletes the authentication" do
      authentication = authentication_fixture()
      assert {:ok, %Authentication{}} = Accounts.delete_authentication(authentication)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_authentication!(authentication.id) end
    end

    test "change_authentication/1 returns a authentication changeset" do
      authentication = authentication_fixture()
      assert %Ecto.Changeset{} = Accounts.change_authentication(authentication)
    end
  end
end
