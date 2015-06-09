defmodule EctoAssociations.Repo.Migrations.AddTables do
  use Ecto.Migration

  def change do
    create table(:parents) do
      add :name, :string
    end

    create table(:step_parents) do
      add :name, :string
    end

    create table(:children) do
      add :parent_id,      references(:parents)
      add :step_parent_id, references(:step_parents)
      add :name,           :string
    end

    create table(:grandchildren) do
      add :child_id, references(:children), null: false
      add :name,     :string
    end
  end
end
