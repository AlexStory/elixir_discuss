defmodule Discuss.Comment do
  use Discuss.Web, :model

  @derive {Poison.Encoder, only: [:body, :user]}

  schema "comments" do
    field :body, :string

    # Associations
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :user_id, :topic_id])
    |> validate_required([:body, :user_id, :topic_id])
  end
end
