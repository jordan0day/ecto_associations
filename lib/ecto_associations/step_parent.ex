defmodule EctoAssociations.StepParent do
  use Ecto.Model
  alias EctoAssociations.Repo

  schema "step_parents" do
    field   :name,          :string
    has_many :step_children, EctoAssociations.Child
  end

  def destroy(step_parent) when is_map(step_parent) do
    result = Repo.transaction(fn ->
      EctoAssociations.Child.destroy_for_association(step_parent, :step_children)

      Repo.delete(step_parent)
    end)

    case result do
      {:ok, _} -> :ok
      {:error, error} -> raise error
    end
  end
end