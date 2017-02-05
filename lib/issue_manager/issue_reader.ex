defmodule IssueManager.IssueReader do
  @moduledoc """
  Fetches issues from a data source.
  """
  @user_agent [{"User-agent", "Elixir miller.rex@gmail.com"}]

  def get(user, project) do
    format_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
    # |> get_list()
    # |> Enum.map(fn(i) -> [i.number, i.created_at, i.title] end)
    # |> TableRex.quick_render!(["number", "created_at", "title"])
  end

  # def get_list({:ok, list}), do: list

  def format_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.decode!(body, as: [%IssueManager.Issue{}])}
  end 

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, Poison.decode!(body)}
  end
end
