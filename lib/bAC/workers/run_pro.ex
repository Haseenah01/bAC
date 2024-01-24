defmodule BAC.Workers.RunPro do
  require Logger
  alias BAC.ObMailer
  alias BAC.Customers
  alias BAC.Customers.Customer

  import Bamboo.Email

  use Oban.Pro.Workers.Workflow, queue: :events, max_attempts: 3, tags: ["customer", "email"]

  @impl true
  def process(%Oban.Job{args: %{"customer" => customer_params}} = job) do

    # new_workflow()
    # |> add(:runpro, new(customer_params))
    # |> add(:transcribe, Transcribe.new(args), deps: [:runpro])
    # |> add(:indexing, Indexing.new(args), deps: [:transcode])
    # |> add(:recognize, Recognize.new(args), deps: [:transcode])
    # |> add(:sentiment, Sentiment.new(args), deps: [:transcribe])
    # |> add(:topics, Topics.new(args), deps: [:transcribe])
    # |> add(:notify, Notify.new(args), deps: [:indexing, :recognize, :sentiment])
    # |> Oban.insert_all()


  end
end
