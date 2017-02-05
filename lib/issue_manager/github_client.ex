defmodule IssueManager.GithubClient do
  @moduledoc """
  Fetches issues from a data source.
  """
  @user_agent [{"User-agent", "Elixir miller.rex@gmail.com"}]

  def get(endpoint, user, project) do
    format_url(endpoint, user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
    
    # |> get_list()
    # |> Enum.map(fn(i) -> [i.number, i.created_at, i.title] end)
    # |> TableRex.quick_render!(["number", "created_at", "title"])
  end

  defp format_url(endpoint, user, project) do
    "#{endpoint}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.decode!(body, as: [%IssueManager.Issue{}])}
  end 

  defp handle_response({_, %{status_code: _, body: body}}) do
    {:error, Poison.decode!(body)}
  end
end
