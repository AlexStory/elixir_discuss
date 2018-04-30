defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic
  alias Discuss.Topic.Repo, as: TopicRepo

  plug Discuss.Plugs.RequireAuth when action in [
    :new,
    :create,
    :edit,
    :update,
    :delete
  ]

  def index(conn, _params) do
    topics = Discuss.Topic.Repo.all
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset %Topic{}, %{}
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case TopicRepo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => id})do
    topic = TopicRepo.get id
    changeset = Topic.changeset topic, %{}
    render conn, "edit.html", changeset: changeset, id: id
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    changeset = TopicRepo.get(id)
      |> Topic.changeset(topic)

    case TopicRepo.update(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", id: id, changeset: changeset)
    end
    redirect conn, to: topic_path(conn, :index)
  end

  def delete(conn, %{"id" => id}) do
    TopicRepo.delete(id)

    conn
    |> put_flash(:info, "Deleted Topic")
    |> redirect(to: topic_path(conn, :index))
  end
end
