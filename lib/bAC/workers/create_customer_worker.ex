defmodule BAC.Workers.CreateCustomerWorker do
  use Oban.Worker, queue: :default, max_attempts: 3, tags: ["user", "customer"], unique: [period: 60]

  @impl true
  def perform(job) do

  end
end
