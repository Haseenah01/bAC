defmodule BAC.Workers.Emailjob do
  require Logger
  alias BAC.ObMailer

  import Bamboo.Email

  use Oban.Worker, queue: :events, max_attempts: 3, tags: ["customer", "email"], unique: [period: 60]

  @impl true
  def perform(%Oban.Job{state: state,attempt: attempt,args: %{"to" => to, "subject" => subject, "body" => body}} = job) do
    Logger.info("Job id: #{inspect(job.id)} | Job attempted at: #{inspect(job.attempted_at)}| Job state: #{inspect(job.state)} | Job queue: #{inspect(job.queue)} | #{to} | #{state} | #{attempt}")
    email = new_email(
          to: to,
          from: "bacsupport@gmail.com",
          subject: subject,
          text_body: body
        )
        ObMailer.deliver_now(email)
  end

  # def timeout(_job), do: :timer.seconds(100)
end
