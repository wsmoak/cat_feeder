defmodule CatFeeder do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(CatFeeder.Worker, [arg1, arg2, arg3]),
      worker(I2c, ["i2c-1", 0x13, [name: ProximitySensor]], id: "prox"),
      worker(GpioRpi, [18, :input, [name: InterruptPin]]),
      worker(CatFeeder.ProximityWorker, []),
      worker(I2c, ["i2c-1", 0x60, [name: Stepper]], id: "step"),
      worker(CatFeeder.StepperWorker, []),
    ]

    # {:ok, _} = Nerves.IO.Ethernet.setup :eth0

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CatFeeder.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
