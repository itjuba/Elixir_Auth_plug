defmodule SimpleAPIWeb.UserView do
  use SimpleAPIWeb, :view
  alias SimpleAPIWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("token.json", %{user: user, token: token}) do

    Jason.encode!(%{token: token})

  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      name: user.name,
#      password: user.password,
      address: user.address}
  end
end
