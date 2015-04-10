# NewRelic API client
class NewRelic

  require 'newrelic_api'

  attr_reader :client

  def initialize(opts = {})
    api_key = opts[:api_key] || ENV['NEWRELIC_API_KEY']
    app_name = opts[:app_name] || ENV['NEWRELIC_APP_NAME']

    NewRelicApi.api_key = api_key
    @client = NewRelicApi::Account.
                find(:first).
                applications.
                select{|a|a.name == app_name }.
                first
  end

  def metrics
    @metrics ||= get_metrics
  end

  # =================
  # Formatted metrics
  # =================

  # Percent CPU usage on all cores
  def percent_cpu
    (metrics['CPU'] / 12).round
  end

  # Percent memory usage
  def percent_memory
    (metrics['Memory'] / 64400 * 100).round
  end

  # Error rate
  def error_rate
    metrics['Error Rate'].round(1)
  end

  # Requests per minutes
  def rpm
    metrics['Throughput'].round
  end

  # Average response time (ms)
  def response_time
    metrics['Response Time'].round
  end

  private

  def get_metrics
    metrics = client.threshold_values

    # Convert to a hash
    metrics.inject({}) do |acc, metric|
      acc[metric.name] = metric.metric_value
      acc
    end
  end

end
