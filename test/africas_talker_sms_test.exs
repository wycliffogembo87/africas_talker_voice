defmodule AfricasTalkerSmsTest do
  use ExUnit.Case
  doctest AfricasTalkerSms

  test "sends a non premium sms" do
    assert AfricasTalkerSms.send_non_premium_sms(
             "my_at_username",
             "my_at_api_key",
             "+254711XXXYYY",
             "This is a text message"
           ) == "The supplied authentication is invalid"
  end
end
