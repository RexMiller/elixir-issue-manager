defmodule IssueManager.Formatters.TextTableTest do
  import IssueManager.Formatters.TextTable
  use ExUnit.Case

  test "renders an ascii table for a given list of maps" do
    sample_data() 
    |> render(["c1", "c3"])
    |> IO.puts
  end

  test "get columns from rows" do
    rendered = to_column_data(sample_data(), ["c1", "c3"])
  end

  test "get field lengths for columns" do
    col_data = [ 
      ["c1r1", "c1r2"],
      ["c2-r1", "c2++++r2"],
      ["c3-r1", "c3++r2"]
    ]
    lengths = field_lengths(col_data)
    assert [4, 8, 6] == lengths
  end

  test "render colums as rows" do
    col_data = [ 
      ["c1-r1", "c1-r2"],
      ["c2-r1", "c2-r2"],
      ["c3-r1", "c3-r2"]
    ]
    expected = """
    c1-r1 |c2-r1 |c3-r1 
    c1-r2 |c2-r2 |c3-r2 
    """
    rendered = render_columns_as_rows(col_data, [6, 6, 6])
    assert expected == rendered <> "\n"
  end    

  test "render row with field lengths" do
    row = {1, "two", "three"}
    rendered = render_row(row, [5, 5, 5], "|", " ")
    expected = "1    |two  |three"
    assert expected == rendered
  end

  defp sample_data() do
    [
      %{"c1" => "r1-c1", "c2" => "r1-c2", "c3" => "r1-c3"},
      %{"c1" => "r2-c1", "c2" => "r2-c2++", "c3" => "r2-c3++++"}
    ]
  end

  defp get_data_with_atoms() do
    [
      %{:number => 1, :created_at => "2017-01-01T12:41:56Z", :title => "Short title"},
      %{:number => 22, :created_at => "2017-02-05T12:41:56Z", :title => "This is a medium title"},
      %{:number => 333, :created_at => "2017-02-01T12:41:56Z", :title => "This is really really long title, so long, just so long"}
    ]    
  end

  defp get_data() do
    [
      %{"number" => 1, "created_at" => "2017-01-01T12:41:56Z", "title" => "Short title"},
      %{"number" => 22, "created_at" => "2017-02-05T12:41:56Z", "title" => "This is a medium title"},
      %{"number" => 333, "created_at" => "2017-02-01T12:41:56Z", "title" => "This is really really long title, so long, just so long"}
    ]    
  end
end