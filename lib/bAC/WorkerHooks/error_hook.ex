defmodule BAC.WorkerHooks.ErrorHook do
  require Logger


  def after_process(state, job) when state in [:discard, :error] do
    error = job.unsaved_error
    extra = Map.take(job, [:attempt, :id, :args, :max_attempts, :meta, :queue, :worker])
    tags = %{oban_worker: job.worker, oban_queue: job.queue, oban_state: job.state}

   #Logger.info("#{error.reason}, stacktrace: #{error.stacktrace}, tags: #{tags}, extra: #{extra}")
   Logger.info(error.reason, stacktrace: error.stacktrace, tags: tags, extra: extra)
  end

  def after_process(_state, _job), do: :ok

end
