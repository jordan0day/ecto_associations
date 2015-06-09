defmodule EctoAssociations.BaseModel do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Model
      use Behaviour

      alias EctoAssociations.Repo

      def destroy_for_association(model, field_name) do
        model
        |> assoc(field_name)
        |> Repo.delete_all
      end

      defoverridable [destroy_for_association: 2]
    end
  end
end