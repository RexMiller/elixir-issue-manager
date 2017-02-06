defmodule IssueManager.ListFormatter.TextTableTest do
  import IssueManager.ListFormatter.TextTable
  use ExUnit.Case

  test "render renders an ascii table for a given list of maps" do
    map_list = [
      %{"number" => 1, "created_at" => "2017-01-01", "title" => "Short title"},
      %{"number" => 22, "created_at" => "2017-02-05", "title" => "This is a medium title"},
      %{"number" => 333, "created_at" => "2017-02-01", "title" => "This is really really long title, so long, just so long"}
    ]
    render(map_list) |> IO.inspect
    get_headers(map_list) |> IO.inspect
    # expected = "+------+------+\n| col0 | col1 |\n+------+------+\n| a    | b    |\n+------+------+\n"
    # assert expected == table    
  end

end