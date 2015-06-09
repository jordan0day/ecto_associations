defmodule EctoAssociations.Parent do
  use Ecto.Model
  alias EctoAssociations.Repo

  schema "parents" do
    field    :name,     :string
    has_many :children, EctoAssociations.Child
  end

  def destroy(parent) when is_map(parent) do
    result = Repo.transaction(fn ->
      EctoAssociations.Child.destroy_for_association(parent, :children)

      Repo.delete(parent)
    end)

    case result do
      {:ok, _} -> :ok
      {:error, error} -> raise error
    end
  end
end