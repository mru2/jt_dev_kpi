require 'json'

SCHEDULER.every '1m', first_in: 0 do

  puts "Fetching metrics for sentry"

  top_errors = Sentry.new(ENV['SENTRY_LOGIN'], ENV['SENTRY_PASSWORD']).top_errors

  # Ugly hack to render a congratulation message as an error
  if top_errors.empty?
    top_errors = [{
      message: 'Nice, no errors at the moment',
      line: 'Congratulations!',
      count: ':)'
    }]
  end

  send_event('top_errors', {value: top_errors.to_json})

end
