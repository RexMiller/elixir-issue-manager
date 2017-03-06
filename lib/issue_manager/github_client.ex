defmodule IssueManager.GithubClient do
  @moduledoc """
  Fetches issues from a data source.
  """

  require Logger

  @user_agent [{"User-agent", "Elixir miller.rex@gmail.com"}]

  def get(endpoint, user, project) do
    Logger.info("Fetching user #{user}, project #{project}")
    format_url(endpoint, user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  defp format_url(endpoint, user, project) do
    "#{endpoint}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info("Response from endpoint: 200")
    Logger.debug(fn -> IO.inspect(body) end)
    {:ok, Poison.decode!(body)}
  end 

  defp handle_response({_, %{status_code: _, body: body}}) do
    {:error, Poison.decode!(body)}
  end
end
