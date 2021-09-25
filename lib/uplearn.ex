defmodule Uplearn do
  @moduledoc """
  Module responsible for fetching and treating html tags from web pages.
  """

  @tags_attributes [{"img", "src"}, {"a","href"}]
  @map_keys ["assets", "links"]

  @doc """
  Fetches attributes values returned from the html body.
  """
  def fetch(url) when is_number(url), do: {:error, "Invalid url"}
  def fetch(url) when is_nil(url), do: {:error, "url is nil"}
  def fetch(url) do
    HTTPoison.get(url)
    |> handle_fetch()
  end

  # treats erros from request
  defp handle_fetch({:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}), do: {:error, "Invalid url"}
  defp handle_fetch({:error, _}), do: {:error, "Invalid url"}

  # treats the values received from the html body
  defp handle_fetch({:ok,  %HTTPoison.Response{body: body}}) do
    Floki.parse_document(body)
    |> elem(1)
    |> get_attributes_values()
  end

  # gets values from the html body tag attributes
  defp get_attributes_values(html) do
    Enum.map(@tags_attributes, fn {tag, attr} ->
      Floki.find(html, tag)
      |> Floki.attribute(attr)
    end)
    |> mapped_data()
  end

  # creates a map containing the keys assets, links
  # and its values
  defp mapped_data(list) do
    Stream.zip(@map_keys, list)
    |> Enum.reduce(%{}, fn {key, value}, map  ->
      Map.put(map, key, value)
    end)

  end
end
