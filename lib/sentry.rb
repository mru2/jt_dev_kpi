# Sentry API client
# Use Watir because fuck it
class Sentry

  def initialize
  end

  def top_errors
    @top_errors ||= get_top_errors
  end

  private

  def get_top_errors
    browser = Browser.new

    # Sign in
    browser.goto('http://sentry.jobteaser.net/login/')
    browser.text_field(id: 'id_username').set ENV['SENTRY_LOGIN']
    browser.text_field(id: 'id_password').set ENV['SENTRY_PASSWORD']
    browser.button(type: 'submit').click

    # Go to the trending page
    browser.goto('http://sentry.jobteaser.net/jobteaser/production/?&sort=accel_15')

    # Fetch the top 5 errors
    divs = browser.divs(css: '.group.level-error:not(.seen)').to_a.first(5)

    binding.pry

  rescue => e

    "None"

  end

end
