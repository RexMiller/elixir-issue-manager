defmodule IssueManager.ListFormatter.TextTable do
  
  def render(map_list) do
    map_list

    # headers = get_headers(map_list)
    # body = get_body(map_list)
    # render(headers, body)
  end

  def get_headers(map_list) do
    map_list
    |> hd()
    |> Map.keys()
    #|> Enum.map(&(Atom.to_string(&1)))
  end

  defp get_body(map_list) do
    val_fn = fn(row) -> Map.values(row) end    
    Enum.map(map_list, val_fn)    
  end

  defp render(headers, body) do
    Enum.join(headers, "|")
    body
    #Enum.map(body, fn([hd | _]) -> "#{hd} " end) #|> Enum.max_by(&(String.length(&1)))


    #TableRex.quick_render!(body, headers)
  end

end