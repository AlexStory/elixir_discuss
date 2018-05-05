defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic
  alias Discuss.Topics

  plug Discuss.Plugs.RequireAuth when action in [:new, :create,
        :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Topics.all
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset %Topic{}, %{}
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => topic_id}) do
      topic = topic_id
      |> Topics.get
      render conn, "show.html", topic: topic
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Topics.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => id})do
    topic = Topics.get id
    changeset = Topic.changeset topic, %{}
    render conn, "edit.html", changeset: changeset, id: id
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    changeset = Topics.get(id)
      |> Topic.changeset(topic)

    case Topics.update(changeset) do
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
    Topics.delete(id)

    conn
    |> put_flash(:info, "Deleted Topic")
    |> redirect(to: topic_path(conn, :index))
  end

  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    topic = Topics.get topic_id
    if topic.user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized")
      |> topic_path(:index)
      |> halt
    end
  end
end
