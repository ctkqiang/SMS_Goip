defmodule SMSTest do
  use ExUnit.Case

  doctest SMS

  test "Monjo Sms (TEST)" do
    ExUnit.configure(exclude: [external: true])
    performance = assert SMS.send()
    assert SMS.send

    monjo_server_writer = fn (filename, data) ->
      File.open(filename, [:append])
        |> elem(1)
        |> IO.binwrite(data)
        |> to_string()
      end

      Enum.each(0..0, fn(_x) ->
        monjo_server_writer.("performance_#{DateTime.utc_now}" ,"#{performance} #{DateTime.to_unix(DateTime.utc_now)} \n")
      end)

  end
end
