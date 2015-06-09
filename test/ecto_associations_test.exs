defmodule EctoAssociationsTest do
  use ExUnit.Case

  alias EctoAssociations.Repo
  alias EctoAssociations.Parent
  alias EctoAssociations.StepParent
  alias EctoAssociations.Child
  alias EctoAssociations.GrandChild

  setup do
    on_exit fn ->
      Repo.delete_all(GrandChild)
      Repo.delete_all(Child)
      Repo.delete_all(StepParent)
      Repo.delete_all(Parent)
    end

    :ok
  end

  test "create a parent" do
    parent = %Parent{name: "test parent"}
             |> Repo.insert

    assert parent != nil
    assert parent.id > 0
  end

  test "create a parent and child" do
    parent = %Parent{name: "test parent"}
             |> Repo.insert

    child = %Child{name: "test child", parent_id: parent.id}
            |> Repo.insert

    assert child != nil
    assert child.id > 0
  end

  test "delete associated children" do
    parent = %Parent{name: "test parent"}
             |> Repo.insert

    child1 = %Child{name: "test child1", parent_id: parent.id}
             |> Repo.insert

    child2 = %Child{name: "test child2", parent_id: parent.id}
            |> Repo.insert

    Child.destroy_for_association(parent, :children)

    assert Repo.get(Child, child1.id) == nil
    assert Repo.get(Child, child2.id) == nil

  end

  test "delete associated children deletes grandchilden" do
    parent = %Parent{name: "test parent"}
             |> Repo.insert

    child1 = %Child{name: "test child1", parent_id: parent.id}
             |> Repo.insert

    gc1 = %GrandChild{name: "test grandchild1", child_id: child1.id}
          |> Repo.insert

    gc2 = %GrandChild{name: "test grandchild2", child_id: child1.id}
          |> Repo.insert

    Child.destroy_for_association(parent, :children)

    assert Repo.get(GrandChild, gc1.id) == nil
    assert Repo.get(GrandChild, gc2.id) == nil
  end

  test "delete associated children deletes grandchilden works for step-parents too" do
    step_parent = %StepParent{name: "test step parent"}
                  |> Repo.insert

    child1 = %Child{name: "test child1", step_parent_id: step_parent.id}
             |> Repo.insert

    gc1 = %GrandChild{name: "test grandchild1", child_id: child1.id}
          |> Repo.insert

    gc2 = %GrandChild{name: "test grandchild2", child_id: child1.id}
          |> Repo.insert

    Child.destroy_for_association(step_parent, :step_children)

    assert Repo.get(GrandChild, gc1.id) == nil
    assert Repo.get(GrandChild, gc2.id) == nil
  end

  test "destroy parent destroys children and grandchildren" do
    parent = %Parent{name: "test parent"}
             |> Repo.insert

    child1 = %Child{name: "test child1", parent_id: parent.id}
             |> Repo.insert

    gc1 = %GrandChild{name: "test grandchild1", child_id: child1.id}
          |> Repo.insert

    gc2 = %GrandChild{name: "test grandchild2", child_id: child1.id}
          |> Repo.insert

    Parent.destroy(parent)

    assert Repo.get(Parent, parent.id) == nil
    assert Repo.get(Child, child1.id) == nil
    assert Repo.get(GrandChild, gc1.id) == nil
    assert Repo.get(GrandChild, gc2.id) == nil
  end

  test "destroy step parent destroys children and grandchildren" do
    step_parent = %StepParent{name: "test parent"}
                  |> Repo.insert

    child1 = %Child{name: "test child1", step_parent_id: step_parent.id}
             |> Repo.insert

    gc1 = %GrandChild{name: "test grandchild1", child_id: child1.id}
          |> Repo.insert

    gc2 = %GrandChild{name: "test grandchild2", child_id: child1.id}
          |> Repo.insert

    StepParent.destroy(step_parent)

    assert Repo.get(StepParent, step_parent.id) == nil
    assert Repo.get(Child, child1.id) == nil
    assert Repo.get(GrandChild, gc1.id) == nil
    assert Repo.get(GrandChild, gc2.id) == nil
  end
end
