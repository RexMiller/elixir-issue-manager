defmodule IssueManager.Issue do
  @moduledoc """
  A basic issue.
  """

  defstruct(
    number: nil,
    created_at: nil,
    title: nil
  )

  @doc """
  Create an `IssueManager.Issue` struct with values set from a map.

  ## Example
  iex> IssueManager.Issue.create(%{"number" => 1, "created_at" => "2017-01-01", "title" => "An issue"})
  %IssueManager.Issue{created_at: "2017-01-01", number: 1, title: "An issue"}
  """
  def create(source_map) do
    result = struct(__struct__())
    result
    |> Map.to_list()
    |> Enum.reduce(result, fn({k, _}, acc) -> 
         case Map.fetch(source_map, Atom.to_string(k)) do
           {:ok, v} -> %{acc | k => v}
           :error -> acc
         end
       end)
  end

end