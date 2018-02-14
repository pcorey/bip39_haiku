defmodule Bip39Haiku.Mnemonic do
  def generate do
    entropy |> map_onto_wordlist
  end

  defp entropy do
    base =
      :crypto.rand_uniform(8, 16)
      |> :crypto.strong_rand_bytes()

    size =
      base
      |> :erlang.binary_to_list()
      |> length
      |> div(4)

    <<checksum::bits-size(size), _::bits>> = :crypto.hash(:sha256, base)
    <<base::bits, checksum::bits>>
  end

  defp map_onto_wordlist(bytes) do
    wordlist = Application.fetch_env!(:bip39_haiku, :wordlist)

    for <<chunk::11 <- bytes>> do
      Enum.at(wordlist, chunk)
    end
  end
end
