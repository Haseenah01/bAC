defmodule BAC.CustomerValidator do

  def validate_and_extract_dob(id_number) do
    case validate_id_length(id_number) do
      {:ok, _} ->
        {:ok, extract_dob(id_number)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_id_length(id_number) do
    if String.length(id_number) == 13 do
      {:ok, id_number}
    else
      {:error, "Invalid ID number length"}
    end
  end

  def extract_dob(id_number) do
    dob_string = String.slice(id_number, 0..7)
    {year, month, day} = {String.slice(dob_string, 0..3), String.slice(dob_string, 4..5), String.slice(dob_string, 6..7)}
    {:ok, "#{year}-#{month}-#{day}"}
  end

end
