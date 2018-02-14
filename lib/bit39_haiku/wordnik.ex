defmodule Bip39Haiku.Wordnik do
  def get_syllables(word) do
    wordnik_api_key = Application.fetch_env!(:bip39_haiku, :wordnik_api_key)

    endpoint =
      "http://api.wordnik.com/v4/word.json/#{word}/hyphenation?api_key=#{wordnik_api_key}"

    case HTTPotion.get(endpoint) do
      %HTTPotion.Response{status_code: 200, body: body} ->
        body
        |> Poison.decode!()
        |> length

      _ ->
        get_syllables(word)
    end
  end
end
