defmodule SimpleAPIWeb.Auth_plug do
  alias SimpleAPI.Accounts.User
  alias SimpleAPI.Accounts

  alias Plug.Conn
  import Plug.Conn

  def init(opts), do: opts

    def authenticated(conn) do
      IO.puts "auth function"


      case fetch_access_token(conn) do
         :error -> :error
          {:ok,token} ->
          token
          case verify(token) do
            true -> :valid
            {:invalid} -> {:invalid}
            {:expired} -> {:expired}
          end

      end
    end

    def call(conn, _opts) do
      case authenticated(conn) do
      {:invalid} ->
        conn
        |> send_resp(401, "Not Authorized : Invalid JWT !")
        |> halt
        {:expired} ->
        conn
         |> send_resp(401, "Not Authorized : Expired JWT !")
         |> halt

        :error ->
        conn
        |> send_resp(401, "Not Authorized !")
        |> halt
      conn
        :valid ->
        conn
    end

  end



    def fetch_access_token(conn) do
      case Conn.get_req_header(conn, "authorization") do
        [token | _rest] -> {:ok, token}
        _any            -> :error
      end
    end


    def verify(token) do
      data = Phoenix.Token.verify(SimpleAPIWeb.Endpoint, "user auth", token, max_age: 86400)
      IO.inspect data
      case data do
        {:ok,_} -> true
        {:error,:invalid} -> {:invalid}
        {:error, :expired} -> {:expired}
#
      end
    end
  end