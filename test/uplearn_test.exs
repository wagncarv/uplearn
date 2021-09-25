defmodule UplearnTest do
  use ExUnit.Case

  describe "fetch/1" do
    test "when the url is valid, returns a successful response" do
      url = "https://google.com.br"
      expected_response = %{"assets" => [], "links" => ["http://www.google.com.br/"]}
      response = Uplearn.fetch(url)

      assert response = expected_response
    end

    test "when the url is invalid, returns an error message" do
      url = "https://google.xx.br"
      expected_response = {:error, "Invalid url"}
      response = Uplearn.fetch(url)

      assert response == expected_response
    end
  end
end
