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
    
end