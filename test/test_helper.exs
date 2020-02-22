Logger.configure(level: :debug)

ExUnit.start()

{:ok, _pid} = InertiaPhoenix.TestWeb.Endpoint.start_link()

:os.cmd('epmd -daemon')
