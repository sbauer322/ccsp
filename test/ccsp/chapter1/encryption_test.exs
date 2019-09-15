defmodule CCSP.Chapter1.EncryptionTest do
  require StreamData
  use ExUnitProperties
  use ExUnit.Case
  alias CCSP.Chapter1.Encryption
  @moduledoc false

  def message_generator() do
    gen all message <- StreamData.string(:alphanumeric),
            message != "" do
      message
    end
  end

  property "original value should match decrypted value" do
    check all message <- message_generator() do
      {key1, key2} = Encryption.encrypt(message)
      assert key1 != key2
      assert message == Encryption.decrypt(key1, key2)
    end
  end
end
