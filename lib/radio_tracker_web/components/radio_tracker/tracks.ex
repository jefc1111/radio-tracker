defmodule RadioTrackerWeb.TracksView do
  use RadioTrackerWeb, :html
  alias RadioTracker.Helpers.Dates
  alias RadioTracker.Schemas.Track

  embed_templates "../templates/tracks/*"
end
