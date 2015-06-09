EctoAssociations
================

Demonstrates one way to organize ecto models to make cascading deletes somewhat easy.

In a BaseModel class, implements a `destroy_for_association/2` function that merely loads an association for the given model and the field name, and issues a `Repo.delete_all`. (This requires the Repo to be known in the base model class -- could be fixed by passing the repo in as an argument...)

EctoAssociations.GrandChild uses this default implementation.

That implementation is overrideable, however, as shown in EctoAssociations.Child, where the Child implementation first deletes all the GrandChildren, before deleting itself.
