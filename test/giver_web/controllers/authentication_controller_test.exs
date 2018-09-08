defmodule GiverWeb.AuthenticationControllerTest do
  use GiverWeb.ConnCase

  alias Giver.Accounts
  alias Giver.Accounts.Authentication

  @create_attrs %{avatar: "some avatar", email: "some email", nickname: "some nickname", platform: "some platform", refresh_token: "some refresh_token", telphone: "some telphone", token: "some token", token_secret: "some token_secret", uid: "some uid", union_id: "some union_id"}
  @update_attrs %{avatar: "some updated avatar", email: "some updated email", nickname: "some updated nickname", platform: "some updated platform", refresh_token: "some updated refresh_token", telphone: "some updated telphone", token: "some updated token", token_secret: "some updated token_secret", uid: "some updated uid", union_id: "some updated union_id"}
  @invalid_attrs %{avatar: nil, email: nil, nickname: nil, platform: nil, refresh_token: nil, telphone: nil, token: nil, token_secret: nil, uid: nil, union_id: nil}

  def fixture(:authentication) do
    {:ok, authentication} = Accounts.create_authentication(@create_attrs)
    authentication
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all authentications", %{conn: conn} do
      conn = get conn, authentication_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create authentication" do
    test "renders authentication when data is valid", %{conn: conn} do
      conn = post conn, authentication_path(conn, :create), authentication: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, authentication_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar" => "some avatar",
        "email" => "some email",
        "nickname" => "some nickname",
        "platform" => "some platform",
        "refresh_token" => "some refresh_token",
        "telphone" => "some telphone",
        "token" => "some token",
        "token_secret" => "some token_secret",
        "uid" => "some uid",
        "union_id" => "some union_id"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, authentication_path(conn, :create), authentication: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update authentication" do
    setup [:create_authentication]

    test "renders authentication when data is valid", %{conn: conn, authentication: %Authentication{id: id} = authentication} do
      conn = put conn, authentication_path(conn, :update, authentication), authentication: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, authentication_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar" => "some updated avatar",
        "email" => "some updated email",
        "nickname" => "some updated nickname",
        "platform" => "some updated platform",
        "refresh_token" => "some updated refresh_token",
        "telphone" => "some updated telphone",
        "token" => "some updated token",
        "token_secret" => "some updated token_secret",
        "uid" => "some updated uid",
        "union_id" => "some updated union_id"}
    end

    test "renders errors when data is invalid", %{conn: conn, authentication: authentication} do
      conn = put conn, authentication_path(conn, :update, authentication), authentication: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete authentication" do
    setup [:create_authentication]

    test "deletes chosen authentication", %{conn: conn, authentication: authentication} do
      conn = delete conn, authentication_path(conn, :delete, authentication)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, authentication_path(conn, :show, authentication)
      end
    end
  end

  defp create_authentication(_) do
    authentication = fixture(:authentication)
    {:ok, authentication: authentication}
  end
end
