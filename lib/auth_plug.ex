defmodule SimpleAPIWeb.Auth_plug do
  alias SimpleAPI.Accounts.User
  alias SimpleAPI.Accounts

  alias Plug.Conn
  import Plug.Conn

  def init(opts), do: opts

    def authenticated?(conn) do
      IO.puts "auth function"
      kk = fetch_access_token(conn)
      IO.inspect kk

      case fetch_access_token(conn) do
        {:ok, token} -> verify?(token)
        :error -> false
      end
    end

    def call(conn, _opts) do
      if authenticated?(conn) do
        conn
      else
        conn

        |> send_resp(401, "Not authorized !")
        |> halt
      end
    end


    def fetch_access_token(conn) do
      case Conn.get_req_header(conn, "authorization") do
        [token | _rest] -> {:ok, token}
        _any            -> :error
      end
    end


    def verify?(token) do
      data = Phoenix.Token.verify(SimpleAPIWeb.Endpoint, "user auth", token, max_age: 86400)
      IO.inspect data
      case data do
        {:ok,_} -> true
        {:error,:invalid} -> false
      end
    end




  end