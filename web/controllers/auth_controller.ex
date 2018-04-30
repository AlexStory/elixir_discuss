defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth
  alias Discuss.User.Repo, as: UserRepo
  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token,
      email: auth.info.email,
      provider: "github"
    }

    changeset = Discuss.User.changeset(%User{}, user_params)
    sign_in conn, changeset
  end

  def signout(conn, _params) do
    conn
    |> put_flash(:info, "Logged out")
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  ## HELPER FUNCTIONS
  defp sign_in(conn, changeset) do
    case UserRepo.upsert(changeset) do
      {:ok, user} ->
        IO.puts "+++++++++++ \n#{user.email} logged in\n+++++++++++"

        conn
        |> put_flash(:info, "Logged in")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

end
