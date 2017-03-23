defmodule IssueManager.Cli do
  @moduledoc """
  Parses command line args and dispatches commands.
  """

  alias IssueManager.GithubClient, as: Github
  alias IssueManager.Issue, as: Issue
  import IssueManager.Formatters.TextTable

  @default_count 2
  @api_endpoint Application.get_env(:issue_manager, :github_api_endpoint)

  @doc """
  Fetches a list of top n issues from a github project and formats them as a table.
  
  argv is a list and can contain --help or -h which returns :help, otherwise list 
  elements will be parsed as Github username, project and count. 

  ## Example
  `IssueManager.Cli.run(["phoenixframework", "phoenix"])`
  """
  def main(argv) do
    argv
    |> parse_args()
    |> execute()
    |> IO.puts
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

  defp execute(:help) do
    IO.puts """
    Usage: issues_manager <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  defp execute({user, project, count}) do
    Github.get(@api_endpoint, user, project)
    |> decode_response()
    |> Enum.take(count)
    |> sort_ascending()
    |> Enum.map(fn(issue_map) -> Issue.create(issue_map) end)   
    |> render_table([:number, :created_at, :title], %{:number => "#"})
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
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