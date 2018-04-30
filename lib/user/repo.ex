defmodule Discuss.User.Repo do
  alias Discuss.Repo
  alias Discuss.User
  #import Ecto.Query

  def get(id) do
    Repo.get User, id
  end
  def insert(changeset) do
    Repo.insert changeset
  end

  def upsert(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> insert changeset
      user -> Repo.update(User.changeset(user, changeset.changes))
    end
  end
end
