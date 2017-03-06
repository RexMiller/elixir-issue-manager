defmodule IssueManager.CliTest do
  import IssueManager.Cli
  use ExUnit.Case

  test "Cli.parse_args returns help true for help arg" do
    result = parse_args(["--help"]) 
    assert(:help == result)
  end

  test "Cli.parse_args returns help true for help alias" do
    result = parse_args(["-h"])
    assert(:help == result)
  end

  test "Cli.parse_args returns user, project, count" do
    # returns a tuple in the form of {[matched_args_and_values], [unmatched_values], [invalid_args]}
    {user, project, count} = parse_args(["someuser", "someproject", "10"])
    assert("someuser" == user)
    assert("someproject" == project)
    assert(10 == count)
  end

  test "Cli.parse_args returns user, project, default count" do
    {user, project, count} = parse_args(["someuser", "someproject"])
    assert("someuser" == user)
    assert("someproject" == project)
    assert(10 == count)
  end

  test "sorts in ascending order" do
    sorted = ["c", "a", "b"] 
    |> fake_created_at_map()
    |> sort_ascending()

    result = for row <- sorted, do: Map.get(row, "created_at")
    assert result == ~w{a b c}
  end

  defp fake_created_at_map(list) do
    for element <- list, 
      do: %{"created_at" => element, "other_field" => "don't care'"}
  end

end