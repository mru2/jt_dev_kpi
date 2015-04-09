# Sidekiq polling client
# Manually crawl the backend via watir, no API and easier for sign-in
class Sidekiq

  def initialize
  end

  def metrics
    @metrics ||= get_metrics
  end

  private

  def get_metrics
    browser = Browser.new

    # Sign in
    browser.goto('http://www.jobteaser.com/fr/backend/users/sign_in')
    browser.text_field(id: 'user_email').set ENV['JOBTEASER_LOGIN']
    browser.text_field(id: 'user_password').set ENV['JOBTEASER_PASSWORD']
    browser.input(type: 'submit').click

    # Go to sidekiq admin page
    browser.goto('http://www.jobteaser.com/backend/sidekiq')

    # Fetch counts
    types = [:processed, :failed, :busy, :enqueued, :retries, :scheduled, :dead]
    counts = types.inject({}) do |acc, type|
      innerhtml =  browser.element(css: ".#{type} .count").text
      count = innerhtml.gsub(/,/,'').to_i # Handle numbers like 20,122
      acc[type] = count
      acc
    end

    counts
  ensure
    # Kill the browser
    browser && browser.kill
  end



end
