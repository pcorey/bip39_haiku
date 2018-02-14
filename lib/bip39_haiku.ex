defmodule Bip39Haiku do
  def stream do
    fn -> Bip39Haiku.Mnemonic.generate() end
    |> Stream.repeatedly()
    |> Stream.filter(&Bip39Haiku.Haiku.is_valid?/1)
  end
end
