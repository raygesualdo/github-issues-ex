defmodule Issues.TableFormatter do
  def print_table_for_columns(data, columns) do
    columns_with_widths = get_column_widths(data, columns)
    table_headers = get_table_headers(columns_with_widths)
    table_rows = get_table_rows(data, columns_with_widths)

    (table_headers ++ table_rows)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def get_column_widths(data, columns) do
    widths =
      columns
      |> Enum.map(fn column ->
        Enum.reduce(data, 0, fn row, max ->
          Enum.max([Map.get(row, column) |> to_string() |> String.length(), max])
        end)
      end)

    Enum.zip(columns, widths)
  end

  def get_table_headers(columns) do
    first_row =
      columns
      |> Enum.map(fn {name, width} -> format_header(name) |> String.pad_trailing(width) end)
      |> Enum.join(" | ")

    second_row =
      columns
      |> Enum.map(fn {_, width} -> String.duplicate("-", width) end)
      |> Enum.join("-+-")

    [first_row, second_row]
  end

  def format_header("number"), do: "#"
  def format_header(name), do: name

  def get_table_rows(data, columns) do
    data
    |> Enum.map(fn row ->
      columns
      |> Enum.map(fn {name, width} ->
        Map.get(row, name) |> to_string() |> String.pad_trailing(width)
      end)
      |> Enum.join(" | ")
    end)
  end
end
