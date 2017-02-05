defmodule IssueManager.Cli do
  @moduledoc """
  Parses command line args and dispatches commands.
  """

  @default_count 10
  @api_endpoint Application.get_env(:issue_manager, :github_api_endpoint)

  @doc """
  argv can be --help or -h which returns :help.

  Otherwise will be parsed as Github username, project and count. 

  Returns a tuple of {user, project, count} or :help.
  """
  def run(argv) do
    parse_args(argv)
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

  defp execute_args({user, project, _count}) do
    result = IssueManager.GithubClient.get(@api_endpoint, user, project)
    handle_result(result)
  end

  defp handle_result({:ok, body}), do: Enum.take(body, 3)

  defp handle_result({:error, error}) do
    message = error["message"]
    IO.puts "Error reading issues from source: #{message}"
    System.halt(2)
  end
end