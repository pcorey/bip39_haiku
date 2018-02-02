defmodule Bip39Haiku do
  @api_key "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"

  def generate do
    Bip39Haiku.Wordlist.all()
    |> Enum.map(fn word -> {word, Task.async(fn -> query_word(word) end)} end)
    |> Enum.map(fn {word, task} -> {word, Task.await(task)} end)
    |> IO.inspect()
    |> Enum.map(fn {word, res} -> {word, res.body} end)
  end

  defp query_word(word) do
    "http://api.wordnik.com/v4/word.json/#{word}/hyphenation?api_key=#{@api_key}"
    |> HTTPoison.get!()
  end
end
