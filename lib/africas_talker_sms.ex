defmodule AfricasTalkerSms do
  @moduledoc """
  Request arguments description:

        param: username
          type: binary
          description: Your Africa’s Talking application username.

        param: api_key
          type: binary
          description: Your Africa’s Talking application api_key.

        param: to
          type: binary
          description: A comma separated string of recipients’ phone numbers.

        param: message
          type: binary
          description: The message to be sent.

        param: from
          type: binary
          description:  Your registered short code or alphanumeric,
                        defaults to AFRICASTKNG.

        param: bulk_sms_mode
        type: int
        description:  This is used by the Mobile Service Provider to
                      determine who gets billed for a message sent
                      using a Mobile-Terminated ShortCode.
                      The default value is 1 ( which means that the sender i.e
                      Africa’s Talking account being used, gets charged ).
                      This parameter will be ignored for messages sent using
                      alphanumerics or Mobile-Originated shortcodes.
                      The value must be set to 1 for bulk messages.

      param: enqueue
        type: bool
        description:  This is used for Bulk SMS clients that would like to deliver
                      as many messages to the API before waiting for an
                      acknowledgement from the Telcos.
                      Possible values are 1 to enable and 0 to disable.
                      If enabled, the API will store the messages in a queue and
                      send them out asynchronously after responding to the request.
                      The default value is 1.
                      
      param: keyword
        type: binary
        description:  The keyword to be used for a premium service.
                      Defaults to nil

      param: link_id
        type: binary
        description:  This is used for premium services to send OnDemand messages.
                      We forward the linkId to your application when the user
                      sends a message to your service. Defaults to nil.
      
      param: retry_duration_in_hours
        type: int
        description:  This specifies the number of hours your subscription
                      message should be retried in case it’s not delivered
                      to the subscriber. Defaults to 1.

      param: timeout
        type: int
        description:  This is the number of miliseconds the request should timeout in.
                      Defaults to 5000.

      param: endpoint
        type: binary
        description:  This specifies whether to use the live url endpoint
                      or the sandbox url endpoint. Defaults to live.
  """

  @doc """
  Send non premium sms.

    # API Request (See defaults above)
      param: username,  required
      param: api_key,   required
      param: to,        required
      param: message,   required
      param: sender_id, optional
      param: timeout,   optional
      param: endpoint,  optional
    

    # API Response
      param: SMSMessageData
      type: binary
      description:  A Json binary detailing the eventual result of the sms request. It contains the following fields:
                    Message String: A summary of the total number of recipients the sms was sent to and the total cost incurred.
                    Recipients List: A list of recipients included in the original request. Each recipient is a Map with the following fields:
                    statusCode Integer: This corresponds to the status of the request. Possible values are:
                      100: Processed
                      101: Sent
                      102: Queued
                      401: RiskHold
                      402: InvalidSenderId
                      403: InvalidPhoneNumber
                      404: UnsupportedNumberType
                      405: InsufficientBalance
                      406: UserInBlacklist
                      407: CouldNotRoute
                      500: InternalServerError
                      501: GatewayError
                      502: RejectedByGateway
                    number String: The recipient’s phone number
                    cost String: Amount incurred to send this sms. The format of this string is: (3-digit Currency Code)(space)(Decimal Value) e.g KES 1.00
                    status String: A string indicating whether the sms was sent to this recipient or not. This does not indicate the delivery status of the sms to this recipient.
                    messageId String: The messageId received when the sms was sent.

    ## Examples

        iex> AfricasTalkerSms.send_non_premium_sms("my_at_username", "my_at_api_key", "+254711XXXYYY", "This is a text message", sender_id: "SENDERID")
        "The supplied authentication is invalid"
    
    ## A sample of a successful response (Json)
        "{\"SMSMessageData\":{\"Message\":\"Sent to 1/1 Total Cost: KES 0.8000\",\"Recipients\":[{\"cost\":\"KES 0.8000\",\"messageId\":\"ATXid_3b534efa3ea126c4893d656d61c17e59\",\"messageParts\":1,\"number\":\"+254711XXXYYY\",\"status\":\"Success\",\"statusCode\":102}]}}"

  """

  # miliseconds
  @default_timeout 5000
  @default_sender_id "AFRICASTKNG"
  @default_enqueue 1
  @default_endpoint "live"

  def send_non_premium_sms(
        username,
        api_key,
        to,
        message,
        options \\ []
      ) do
    defaults = [
      sender_id: @default_sender_id,
      enqueue: @default_enqueue,
      timeout: @default_timeout,
      endpoint: @default_endpoint
    ]

    options = Keyword.merge(defaults, options) |> Enum.into(%{})

    timeout = Map.get(options, :timeout)

    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        &AfricasTalkerSms.Worker.send_non_premium_sms(
          &1,
          username,
          api_key,
          to,
          message,
          options
        ),
        timeout
      )
    end)
    |> Task.await(timeout)
  end
end
