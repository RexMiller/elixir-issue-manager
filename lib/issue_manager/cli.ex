defmodule IssueManager.Cli do
  @moduledoc """
  Parses command line args and dispatches commands.
  """

  import IssueManager.GithubClient
  import IssueManager.Formatters.TextTable

  @default_count 2
  @api_endpoint Application.get_env(:issue_manager, :github_api_endpoint)

  @doc """
  argv can be --help or -h which returns :help.

  Otherwise will be parsed as Github username, project and count. 

  Returns a tuple of {user, project, count} or :help.
  """
  def run(argv) do
    argv 
    |> parse_args()
    |> execute_args()
  end

  @doc """
  Parses command arguments as :help or user, project, count
  """
  def parse_args(argv) do
    parsed = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parsed do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end

  defp execute_args(:help) do
    IO.puts """
    Usage: issues_manager <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  defp execute_args({user, project, count}) do
    get(@api_endpoint, user, project)
    |> handle_result()
    |> Enum.take(count)
    |> sort_ascending()
    |> render(["number", "created_at", "title"], %{"number" => "#"})
  end

  defp handle_result({:ok, body}), do: body

  defp handle_result({:error, error}) do
    message = error["message"]
    IO.puts "Error reading issues from source: #{message}"
    System.halt(2)
  end

  @doc """
  Sorts by "created_at" field
  """
  def sort_ascending(data, sort_by \\ "created_at") do
    Enum.sort(data, fn(row, next_row) -> row[sort_by] < next_row[sort_by] end) 
  end
end