queued = Numeric.new
failed = Numeric.new

SCHEDULER.every '1m', first_in: 0 do

  puts "Fetching metrics for sidekiq"

  metrics = Sidekiq.new(ENV['JOBTEASER_LOGIN'], ENV['JOBTEASER_PASSWORD']).metrics

  send_event('sidekiq_queued_jobs', queued.push(metrics[:enqueued]))
  send_event('sidekiq_failed_jobs', failed.push(metrics[:failed]))

end
