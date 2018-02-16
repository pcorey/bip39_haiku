defmodule Bip39Haiku.Haiku do
  def is_valid?(wordlist) do
    IO.ANSI.format([
      :black,
      :bright,
      "Checking \"#{Enum.join(wordlist, " ")}\"..."
    ])
    |> IO.puts()

    wordlist = attach_syllables(wordlist)

    with {:ok, wordlist} <- drop_syllables(wordlist, 5),
         {:ok, wordlist} <- drop_syllables(wordlist, 7),
         {:ok, wordlist} <- drop_syllables(wordlist, 5) do
      Enum.empty?(wordlist)
    else
      _ -> false
    end
  end

  defp attach_syllables(wordlist) do
    wordlist
    |> Enum.map(
      &Task.async(fn ->
        {&1, Bip39Haiku.Wordnik.get_syllables(&1)}
      end)
    )
    |> Enum.map(&Task.await/1)
  end

  def drop_syllables(
        wordlist,
        syllables
      ) do
    total_syllables =
      wordlist
      |> Enum.scan(0, fn {word, syllables}, total ->
        total + syllables
      end)

    index =
      total_syllables
      |> Enum.find_index(&(&1 == syllables))

    case index do
      nil ->
        {:error, :not_possible}

      index ->
        {:ok, Enum.drop(wordlist, index + 1)}
    end
  end
end
