defmodule EctoAssociations.Child do
  use EctoAssociations.BaseModel
  alias EctoAssociations.Repo

  schema "children" do
    field      :name,         :string
    belongs_to :parent,        EctoAssociations.Parent
    belongs_to :step_parent,   EctoAssociations.StepParent
    has_many   :grandchildren, EctoAssociations.GrandChild
  end

  def destroy(child) when is_map(child) do
    destroy(child.id)
  end

  def destroy_for_association(model, field_name) do
    result = Repo.transaction(fn ->
      assoc_query = assoc(model, field_name)

      assoc_query
      |> Repo.all
      |> EctoAssociations.GrandChild.destroy_for_association(:grandchildren)

      Repo.delete_all assoc_query
    end)

    case result do
      {:ok, _} -> :ok
      {:error, error} -> raise error
    end
  end
end