defmodule IssueManager.GithubClient do
  @moduledoc """
  Fetches issues from a data source.
  """

  require Logger

  @user_agent [{"User-agent", "Elixir miller.rex@gmail.com"}]

  def get(endpoint, user, project) do
    format_url(endpoint, user, project)
    |> log_inline("GET ~s")
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  defp format_url(endpoint, user, project) do
    "#{endpoint}/repos/#{user}/#{project}/issues"
  end

  defp log_inline(value, format) do
    :io_lib.format(format, [value])
    |> List.to_string()
    |> Logger.info

    value
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
