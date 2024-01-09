# defmodule BAC.EmailSend do
#   use GenSMTP.Client, otp_app: :bAC

#   def send_email do
#     {:ok, connection} = connect()

#     email = %{
#       from: "sipho@gmail.com",
#       to: "siphonhata@gmail.com",
#       subject: "Hello, Elixir!",
#       body: "This is the body of the email."
#     }

#     message = GenSMTP.Message.compose(email)

#     send(connection, message)

#     disconnect(connection)
#   end

# end
