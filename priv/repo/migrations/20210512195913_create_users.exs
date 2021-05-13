defmodule SimpleAPI.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :name, :string
      add :password, :string
      add :address, :string

      timestamps()
    end

  end
end