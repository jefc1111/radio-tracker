defmodule RadioTrackerWeb.UserSessionController do
  use RadioTrackerWeb, :controller

  alias RadioTracker.Accounts
  alias RadioTrackerWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      msg = case Accounts.registration_pending?(email) do
        true -> "Please complete the registration process."
        _ -> "Invalid email or password"
      end
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: msg)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
