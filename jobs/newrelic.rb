# Store values for RPM and response time in order to send graph points
# Defined out of the scheduler so they are persisted between polls
rpm = Graph.new(60) # 60 points, 1 per minute => 1 hour history
response_time = Graph.new(60)

SCHEDULER.every '1m', first_in: 0 do

  # Fetch data all at once, but push it in separate events
  newrelic = NewRelic.new

  send_event('cpu_load', { value: newrelic.percent_cpu })
  send_event('memory_usage', { value: newrelic.percent_memory })
  send_event('error_rate', { value: newrelic.error_rate })
  send_event('requests_per_minute', rpm.push(newrelic.rpm))
  send_event('average_response_time', response_time.push(newrelic.response_time))

end
