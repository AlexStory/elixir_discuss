defmodule Discuss.Comments do
  alias Discuss.Repo

  def insert(comment) do
    Repo.insert comment
  end
end
