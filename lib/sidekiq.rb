# Sidekiq polling client
# Manually crawl the backend via watir, no API and easier for sign-in
class Sidekiq

  require 'mechanize'

  def initialize(login, password)
    @login = login
    @password = password
  end

  def metrics
    @metrics ||= get_metrics
  end

  private

  def get_metrics
    browser = Mechanize.new

    # Sign in
    browser.get('http://www.jobteaser.com/fr/backend/users/sign_in') do |login_page|
      login_form = login_page.form_with(action: '/fr/backend/users/sign_in')
      login_form['user[email]'] = @login
      login_form['user[password]'] = @password
      login_form.submit
    end

    # Go to sidekiq admin page
    sidekiq_dashboard = browser.get('http://www.jobteaser.com/backend/sidekiq')

    # Fetch counts
    types = [:processed, :failed, :busy, :enqueued, :retries, :scheduled, :dead]
    counts = types.inject({}) do |acc, type|
      innerhtml =  sidekiq_dashboard.search(".#{type} .count").text
      count = innerhtml.gsub(/,/,'').to_i # Handle numbers like 20,122
      acc[type] = count
      acc
    end
  end
end
