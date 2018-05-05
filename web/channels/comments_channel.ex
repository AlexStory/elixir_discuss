defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.{Topics, Comments}

  def join("comments:" <> topic_id, _params, socket) do
    topic = Topics.get_with_comments! topic_id
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id
    changeset = topic
      |> build_assoc(:comments, body: content, user_id: user_id)

    case Comments.insert(changeset) do
      {:ok, comment} ->
        Discuss.Endpoint.broadcast("comments:#{topic.id}", "new_topic", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, {:ok, %{topic_id: topic.id}}, socket}
  end
end
