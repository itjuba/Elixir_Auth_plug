defmodule SimpleAPIWeb.UserController do
  use SimpleAPIWeb, :controller

  alias SimpleAPI.Accounts
  alias SimpleAPI.Accounts.User
  alias Plug.Conn
  import Plug.Conn

  action_fallback SimpleAPIWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
    #  |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("token.json", %{user: user,token: Phoenix.Token.sign(SimpleAPIWeb.Endpoint, "user auth", user.id)})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end


  def auth(conn,%{"user" => user}) do
      try do
      u = Accounts.get_user_by(user["username"])

      cond do
        u && Pbkdf2.verify_pass(user["password"], u.password) ->
          conn
          |> render("token.json", %{user: user,token: Phoenix.Token.sign(SimpleAPIWeb.Endpoint, "user auth", u.id)})

        u ->
          conn
          |> put_status(401)
          |> json(%{error: %{code: 400, message: "Unable to login with provided credentials "}})
      end
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(404)
      |> json(%{error: %{code: 404, message: "User not found"}})

  end
  end


  def get_user_by(conn,%{"username" => username}) do
    IO.puts "hererer"
    IO.inspect username
    user = Accounts.get_user_by(username)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end



end
