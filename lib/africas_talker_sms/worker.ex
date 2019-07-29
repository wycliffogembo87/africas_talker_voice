defmodule AfricasTalkerSms.Worker do
  use GenServer

  require Logger

  @urls %{
    "live" => "https://api.africastalking.com/version1/messaging",
    "sandbox" => "https://api.sandbox.africastalking.com/version1/messaging"
  }

  #####
  # External API

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def send_non_premium_sms(worker, username, api_key, to, message, options) do
    Logger.info("Pool worker: #{__MODULE__}: #{inspect(worker)}")

    GenServer.call(
      worker,
      {:send_non_premium_sms, username, api_key, to, message, options},
      Map.get(options, :timeout)
    )
  end

  #####
  ## GenServer Implementation

  def init(_) do
    Logger.info(
      "Starting #{inspect(__MODULE__)}; " <>
        "#{inspect(self())} pool worker..."
    )

    {:ok, nil}
  end

  def handle_call(
        {:send_non_premium_sms, username, api_key, to, message, options},
        _caller,
        state
      ) do
    body =
      {:form,
       [
         {"username", username},
         {"to", to},
         {"message", message},
         {"from", Map.get(options, :sender_id)},
         {"enqueue", Map.get(options, :enqueue)},
         {"bulkSMSMode", 1}
       ]}

    Logger.info("Messaging Body: #{inspect(body)}")

    url = Map.get(@urls, Map.get(options, :endpoint))

    headers = [
      Apikey: api_key,
      Accept: "Application/json",
      "Content-type": "application/x-www-form-urlencoded"
    ]

    options = [ssl: [{:versions, [:"tlsv1.2"]}]]

    response = HTTPoison.post!(url, body, headers, options)
    # Posting to https://httpbin.org/post reflects back what you send it
    # Perfect for troubleshooting http(s) url invocation

    {:reply, Map.get(response, :body), state}
  end
end
