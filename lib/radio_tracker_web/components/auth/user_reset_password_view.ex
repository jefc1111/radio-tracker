defmodule RadioTrackerWeb.UserResetPasswordView do
  use RadioTrackerWeb, :html

  import RadioTrackerWeb.Components.FormField
  import RadioTrackerWeb.Components.ButtonWithIcon
  import RadioTrackerWeb.Components.Form.Wrapper

  embed_templates "../templates/auth/user_reset_password/*"
end
