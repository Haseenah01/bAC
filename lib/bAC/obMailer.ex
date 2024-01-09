defmodule BAC.ObMailer do
  use Bamboo.Mailer, otp_app: :bAC

  def deliver_many(emails, _opts \\ []) when is_list(emails) do
    for email <- emails do
      %{"to" => email.to, "subject" => email.subject, "body" => email.body}
      |> BAC.Workers.EmailJob.new()
    end
    |> Stream.chunk_every(5000)
    |> Task.async_stream(fn jobs ->
      # Insert jobs in batches of 5k to avoid parameter limitations
      Oban.insert_all(fn _ ->
        jobs
      end)
    end)
    |> Stream.run()
  end

  def deliver_many1(emails, _opts \\ []) when is_list(emails) do

    for email <- emails do
      %{"to" => email.email, "subject" => "email.subject", "body" => "email.body"}
      |> BAC.Workers.EmailJob.new()
    end
    |> Stream.chunk_every(5000)
    |> Task.async_stream(fn jobs ->
      # Insert jobs in batches of 5k to avoid parameter limitations
      Oban.insert_all(fn _ ->
        jobs
      end)
    end)
    |> Stream.run()
  end
end
