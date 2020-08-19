#! /usr/bin/env elixir
# +--------------------------------+
# | MONJO GOIP TECHNICAL PROTOCOLS |
# +--------------------------------+
# +-------------+------------------+--+-----------------+-------------------------------------+
# |   channel:  |        "1"       |  |      auth:      |       "Basic YWRtaW46YWRtaW4="      |
# +-------------+------------------+--+-----------------+-------------------------------------+
# |   action:   |       "sms"      |  |     accept:     |                "*/*"                |
# +-------------+------------------+--+-----------------+-------------------------------------+
# |   telnum:   | "#{user_define}" |  |  content-type:  | "application/x-www-form-urlencoded" |
# +-------------+------------------+--+-----------------+-------------------------------------+
# | smscontent: | "#{user_define}" |  | content-length: |                "125"                |
# +-------------+------------------+--+-----------------+-------------------------------------+
# |   smskey:   |    1162480578    |  |                 |                                     |
# +-------------+------------------+--+-----------------+-------------------------------------+
# defmodule SMS Send OTP SMS to Phone Number Specified
defmodule SMS do
  require Logger

  def send do
    # Virtual Code Generate By Random
    vcode = Enum.random(1_00000..9_99999)
    # Host of the SMS Gateway
    host = "10.0.0.59"
    # Port of the Gateway
    port = 80
    # Line Channel number
    line = "1"
    # Action service
    action = "sms"
    # Get User Telephone Number
    telnum = IO.gets("Enter your phone number: ") |> String.trim()
    # Monjo OTP Message with Generated Code
    smscontent = "Monjo: Your Account Verification Code is #{vcode}"

    # HTTP "POST" REQUEST
    {:ok, conn} = Mint.HTTP1.connect(:http, "#{host}", 80)

    {:ok, conn, request_ref} =
      Mint.HTTP1.request(
        conn,
        "POST",
        "/default/en_US/sms_info.html?",
        [
          {"Authorization", "Basic YWRtaW46YWRtaW4="},
          {"Accept", "*/*"},
          {"Content-Type", "application/x-www-form-urlencoded"},
          {"Content-Length", "125"}
        ],
        "line=1&action=#{action}&telnum=#{telnum}&smscontent=#{smscontent}&smskey=1162480578"
      )

    # Checks wether it work
    if conn == nil do
      Logger.info("Connection to #{host} at #{port} {:failed}")
    else
      Logger.info("Connected to #{host} at #{port} {:success}")
    end

    # On Receiving Responses, IO print out Reponses
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP1.stream(conn, message)

        # TODO JOHN WRITE {APPEND} FILES HERE
        # Checks is there such Files &&  Write File and Append
        dir_log = "log/monjo.log"
        file_existence = File.exists?(dir_log)
        today = Date.utc_today()

        if file_existence == true do
          Logger.debug("File Requested Do Exist, append to file now ")

          monjo_server_writer = fn filename, data ->
            File.open(filename, [:append])
            |> elem(1)
            |> IO.binwrite(data)
            |> to_string()
          end

          Enum.each(0..0, fn x ->
            ## {dir_log}_#{DateTime.utc_now}
            monjo_server_writer.(
              "#{dir_log}",
              "For #{telnum} Received \"#{smscontent} \" at #{today} : #{
                DateTime.to_unix(DateTime.utc_now())
              } \n"
            )
          end)
        else
          Logger.debug("File Requested Do not Exist \n Creating file...")

          monjo_server_writer = fn filename, data ->
            File.open(filename, [:append])
            |> elem(1)
            |> IO.binwrite(data)
            |> to_string()
          end

          Enum.each(0..0, fn x ->
            monjo_server_writer.(
              "#{dir_log}",
              "For #{telnum} Received \"#{smscontent} \" at #{today} : #{
                DateTime.to_unix(DateTime.utc_now())
              } \n"
            )
          end)
        end
    end

    {:ok, conn} = Mint.HTTP.close(conn)
  end
end

# TODO JOHN what If simCard == null?
# TODO JOHN QUEUEING
