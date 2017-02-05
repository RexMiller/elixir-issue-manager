defmodule IssueManager.Issue do
  @moduledoc """
  A basic issue.
  """

  defstruct(
    number: nil,
    created_at: nil,
    title: nil
  )

end