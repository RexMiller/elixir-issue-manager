defmodule IssueManager.GithubClientTest do
  alias IssueManager.GithubClient, as: Client
  use ExUnit.Case

  @moduletag :integration
  @api_endpoint Application.get_env(:issue_manager, :github_api_endpoint)

  test "GithubClient.get returns issues response for valid user project" do
    {:ok, body} = Client.get(@api_endpoint, "phoenixframework", "phoenix")
    IO.inspect body
    assert is_list(body)
  end

  test "GithubClient.get returns error response for invalid user project" do
    {:error, _} = Client.get(@api_endpoint, "asdfasd", "asdfasd")
  end

end