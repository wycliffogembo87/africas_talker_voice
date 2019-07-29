defmodule AfricasTalkerSms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @default_poolboy_size 20
  @default_poolboy_overflow 5

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: AfricasTalkerSms.Worker.start_link(arg)
      # {AfricasTalkerSms.Worker, arg}
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AfricasTalkerSms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def poolboy_config do
    [
      {:name, {:local, :worker}},
      {:worker_module, AfricasTalkerSms.Worker},
      {:size, Application.get_env(:africas_talker_sms, :size, @default_poolboy_size)},
      {:max_overflow,
       Application.get_env(:africas_talker_sms, :max_overflow, @default_poolboy_overflow)}
    ]
  end
end
