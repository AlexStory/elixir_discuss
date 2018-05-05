defmodule Discuss.Topics do
  alias Discuss.{Topic, Repo}
  # import Ecto.Query

  def all() do
    Repo.all(Topic)
  end

  def get(id) do
    Repo.get Topic, id
  end

  def get!(id) do
    Repo.get! Topic, id
  end

  def get_with_comments!(id) do
    Repo.get!(Topic, id)
    |> Repo.preload(comments: [:user])
  end

  def update(changeset) do
    Repo.update changeset
  end

  def insert(changeset) do
    Repo.insert changeset
  end

  def delete(id) do
    Repo.get!(Topic, id)
    |> Repo.delete
  end
end
