defmodule IssueManager.Formatters.TextTable do

  # @lengths %{"number" => 4, "created_at" => 20, "title" => 50}

  # def render(data, field_list, aliases \\ %{}) do
  #   table_data = Enum.map(data, fn(row) -> with_fields(row, field_list) end)

  #   """
  #   #{render_headers(field_list, aliases)}
  #   #{render_divider(field_list)}
  #   #{render_body(table_data)}    
  #   """
  # end

  # defp with_fields(row, field_list) do
  #   field_list
  #   |> Enum.map(fn(key) -> {key, row[key]} end)
  # end

  def render(data, fields, aliases \\ []) do
    with col_data = to_column_data(data, fields),
        lengths = field_lengths(col_data),
      do: render_columns_as_rows(col_data, lengths)
  end

  def to_column_data(data, fields) do
    Enum.map(fields, fn(field) -> 
      for row <- data, do: row[field] 
    end)
  end

  def field_lengths(col_data) do
    for col <- col_data, 
      do: col |> Enum.map(&(String.length("#{&1}"))) |> Enum.max()
  end

  def render_headers(field_list, lengths, aliases) do
    # field_list
    # |> Enum.reduce([], fn(key, row) -> List.insert_at(row, -1, {key, Map.get(aliases, key, key)}) end)
    # |> render_row(" | ", " ")    
  end

  def render_divider(field_list) do
    # field_list
    # |> Enum.reduce([], fn(key, row) -> List.insert_at(row, -1, {key, "-"}) end)
    # |> render_row("-+-", "-")    
  end

  # def render_body(data) do
  #   data
  #   |> Enum.map(fn(row) -> render_row(row, " | ", " ") end)
  #   |> Enum.join("\n")
  # end

  def render_columns_as_rows(col_data, lengths) do
    col_data 
    |> List.zip() 
    |> Enum.map(fn(row) -> render_row(row, lengths, "|", " ") end)
    |> Enum.join("\n")
  end

  # def render_row(row, delimiter, pad_char) do
  #   row 
  #   |> Enum.map(fn({key, value}) -> render_field(value, @lengths[key], pad_char) end) 
  #   |> Enum.join(delimiter)
  # end

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