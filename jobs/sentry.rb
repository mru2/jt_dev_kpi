require 'json'

SCHEDULER.every '15m', first_in: 0 do

  puts "Fetching metrics for sentry"

  # top_errors = Sentry.new.top_errors

  # if top_errors.nil?
  #   top_errors = [{
  #     message: 'Hey, no errors at the moment',
  #     line: 'Congratulations!',
  #     count: ':)'
  #   }]
  # elsif top_errors == :failure
    top_errors = [{
      message: 'An error happened',
      line: 'Is sentry down?',
      count: 500
    }]
  # end

  # puts "Got errors #{top_errors}"

  send_event('top_errors', {value: top_errors.to_json})

end
