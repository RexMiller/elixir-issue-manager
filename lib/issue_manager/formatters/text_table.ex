defmodule IssueManager.Formatters.TextTable do

  def render_table(data, fields, aliases \\ %{}) do
    with col_data = to_column_data(data, fields),
        lengths = field_lengths(col_data)
    do
      [
        render_headers(fields, lengths, aliases),
        render_divider(lengths),
        render_columns_as_rows(col_data, lengths)
      ]
      |> Enum.join("\n")
    end
  end

  def to_column_data(data, fields) do
    Enum.map(fields, fn(field) -> 
      for row <- data
      do 
        {:ok, value} = Map.fetch(row, field)
        value 
      end
    end)
  end

  def field_lengths(col_data) do
    for col <- col_data, 
      do: col |> Enum.map(&(String.length("#{&1}"))) |> Enum.max()
  end

  def render_headers(fields, lengths, aliases \\ %{}) do
    fields
    |> Enum.map(&(Map.get(aliases, &1, &1)))
    |> List.to_tuple()
    |> render_row(lengths, "|", " ")
  end

  def render_divider(lengths) do
    Enum.map_join(lengths, "+", &(String.duplicate("-", &1)))
  end

  def render_columns_as_rows(col_data, lengths) do
    col_data 
    |> List.zip() 
    |> Enum.map(fn(row) -> render_row(row, lengths, "|", " ") end)
    |> Enum.join("\n")
  end

  def render_row(row_tuple, lengths, delimiter, pad_char) do
    row_tuple
    |> Tuple.to_list()
    |> Enum.zip(lengths)
    |> Enum.map(fn({field, length}) -> render_field(field, length, pad_char) end)
    |> Enum.join(delimiter)
  end

  defp render_field(value, length, pad_char) do
    padding = max(0, length - String.length("#{value}"))
    "#{value}#{String.duplicate(pad_char, padding)}"
  end

end