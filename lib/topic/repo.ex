defmodule Discuss.Topic.Repo do
  alias Discuss.Topic
  # import Ecto.Query

  def all() do
    Discuss.Repo.all(Topic)
  end

  def get(id) do
    Discuss.Repo.get Topic, id
  end

  def update(changeset) do
    Discuss.Repo.update changeset
  end

  def insert(changeset) do
    Discuss.Repo.insert changeset
  end

  def delete(id) do
    Discuss.Repo.get!(Topic, id)
    |> Discuss.Repo.delete
  end
end
