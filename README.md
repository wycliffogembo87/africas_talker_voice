# AfricasTalkerSms

**Elixir wrapper over the Africastalking SMS API**

## Installation

```elixir
def deps do
  [
    {:africas_talker_sms, "~> 0.1.0"}
  ]
end
```

## Configuration

This application uses poolboy to limit muximum number of concurrent processes.
The default maximum pool size is 20 and the default overflow i.e maximum number
of temporary workers created is when the pool is empty is 5.

To change these defaults, set the size and overflow parameters to your config file.

Example:

```elixir
config :africas_talker_sms, size: 100, overflow: 10 
```

