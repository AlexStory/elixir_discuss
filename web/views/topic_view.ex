defmodule Discuss.TopicView do
  use Discuss.Web, :view

  def user_owns_topic(conn, topic) do
    conn.assigns.user && conn.assigns.user.id == topic.user_id
  end
end
