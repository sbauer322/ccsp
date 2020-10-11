defmodule CCSP.Chapter1.Encryption do
  use Bitwise, only_operators: true

  @moduledoc """
  Corresponds to CCSP in Python, Section 1.3, titled "Unbreakable Encryption"
  """

  @spec random_key(non_neg_integer) :: non_neg_integer
  defp random_key(length) do
    :crypto.strong_rand_bytes(length)
    |> :crypto.bytes_to_integer()
  end

  @spec encrypt(String.t()) :: {non_neg_integer, non_neg_integer}
  def encrypt(original) do
    dummy_key = random_key(byte_size(original))
    original_key = :crypto.bytes_to_integer(original)
    encrypted_key = original_key ^^^ dummy_key
    {dummy_key, encrypted_key}
  end

  @doc """
  The ordering of the keys does not impact the result.
  """
  @spec decrypt({non_neg_integer, non_neg_integer}) :: String.t()
  def decrypt(keyPair)

  def decrypt({key1, key2}) do
    decrypted = key1 ^^^ key2
    :binary.encode_unsigned(decrypted)
  end

  def decrypt(key1, key2) do
    decrypt({key1, key2})
  end
end
