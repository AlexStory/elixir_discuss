defmodule Discuss.Topic.Repo do
  alias Discuss.Topic

  def all() do
    Discuss.Repo.all(Topic)
  end
end
