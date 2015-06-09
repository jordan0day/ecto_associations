defmodule EctoAssociations.GrandChild do
  use EctoAssociations.BaseModel

  alias EctoAssociations.Repo

  schema "grandchildren" do
    field      :name,  :string
    belongs_to :child, EctoAssociations.Child
  end
end