SCHEDULER.every '1m', first_in: 0 do

  newrelic = NewRelic.new

  # Fetch data all at once, but push it in separate events

  send_event('newrelic_cpu', { value: newrelic.percent_cpu })
  send_event('newrelic_memory', { value: newrelic.percent_memory })

end
