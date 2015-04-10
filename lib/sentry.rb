# Sentry API client
# Use Watir because fuck it
class Sentry

  require 'mechanize'
  require 'httparty'

  def initialize(login, password)
    @login = login
    @password = password
  end

  def top_errors
    @top_errors ||= get_top_errors
  end

  private

  def get_top_errors
    browser = Mechanize.new

    # Sign in
    browser.get('http://sentry.jobteaser.net/login/') do |login_page|
      login_form = login_page.forms.first
      login_form['username'] = @login
      login_form['password'] = @password
      login_form.submit
    end

    # Fetch the connection cookies
    cookies = browser.cookies.inject({}) do |acc, cookie|
      acc[cookie.name] = cookie.value
      acc
    end

    # Fetch the trending issues directly in JSON
    response = HTTParty.get(
      'http://sentry.jobteaser.net/api/jobteaser/production/poll/?sort=accel_15',
      headers: {
        'Content-Type' => 'application/json',
        'Cookie' => cookies.map{|name, value| "#{name}=#{value}"}.join('; '),
        'Referer' => 'http://sentry.jobteaser.net/jobteaser/production/?&sort=accel_15',
        'X-Requested-With' => 'XMLHttpRequest'
      }
    )

    # Parse the response and return the new hot errors
    hot_errors = response.
      select { |error| !error['isResolved'] && error['canResolve'] }.
      map do |error|
        {
          message: error['message'],
          line: error['title'],
          count: error['annotations'].first['count'] # Users impacted
        }
      end

    hot_errors
  end

end
