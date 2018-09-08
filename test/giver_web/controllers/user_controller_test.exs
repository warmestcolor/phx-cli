defmodule GiverWeb.UserControllerTest do
  use GiverWeb.ConnCase

  alias Giver.Accounts
  alias Giver.Accounts.User

  @create_attrs %{avatar: "some avatar", birthday: ~N[2010-04-17 14:00:00.000000], email: "some email", gender: 42, is_active: true, nickname: "some nickname", telphone: "some telphone", username: "some username"}
  @update_attrs %{avatar: "some updated avatar", birthday: ~N[2011-05-18 15:01:01.000000], email: "some updated email", gender: 43, is_active: false, nickname: "some updated nickname", telphone: "some updated telphone", username: "some updated username"}
  @invalid_attrs %{avatar: nil, birthday: nil, email: nil, gender: nil, is_active: nil, nickname: nil, telphone: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar" => "some avatar",
        "birthday" => "2010-04-17T14:00:00.000000",
        "email" => "some email",
        "gender" => 42,
        "is_active" => true,
        "nickname" => "some nickname",
        "telphone" => "some telphone",
        "username" => "some username"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar" => "some updated avatar",
        "birthday" => "2011-05-18T15:01:01.000000",
        "email" => "some updated email",
        "gender" => 43,
        "is_active" => false,
        "nickname" => "some updated nickname",
        "telphone" => "some updated telphone",
        "username" => "some updated username"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
