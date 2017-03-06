defmodule IssueManager.Formatters.TextTableTest do
  import IssueManager.Formatters.TextTable
  use ExUnit.Case

  defmodule Sample do
    defstruct(
      c1: nil, c2: nil, c3: nil
    )    
  end

  test "renders an ascii table for a given list of maps" do
    render_table(sample_data_structs(), [:c1, :c3])
    |> String.split("\n")
    |> (fn(rows) ->
         assert List.first(rows) == "c1   |c3       "
         assert List.last(rows) == "r2-c1|r2-c3++++"
       end).()
  end

  test "renders headers" do
    result = render_headers(["col1", "col2", "col3"], [5, 5, 5])
    assert "col1 |col2 |col3 " == result
  end

  test "renders headers with aliases" do
    result = render_headers(["col1", "col2", "col3"], [5, 5, 5], %{"col3" => "fld3"})
    assert "col1 |col2 |fld3 " == result
  end

  test "get columns from rows" do
    rendered = to_column_data(sample_data(), ["c1", "c3"])
    expected = [["r1-c1", "r2-c1"], ["r1-c3", "r2-c3++++"]]
    assert expected == rendered
  end

  test "get columns from rows for structs" do
    rendered = to_column_data(sample_data_structs(), [:c1, :c3])
    expected = [["r1-c1", "r2-c1"], ["r1-c3", "r2-c3++++"]]
    assert expected == rendered
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

  defp sample_data_structs() do
    [
      %Sample{:c1 => "r1-c1", :c2 => "r1-c2", :c3 => "r1-c3"},
      %Sample{:c1 => "r2-c1", :c2 => "r2-c2++", :c3 => "r2-c3++++"}
    ]
  end

end