# This class represent a Watir Browser, and can be instanciated headless or not, and with a custom language.
# it's pre-configured, and all the methods but kill and new are redirectd to the browser WATIR
# kill will kill the browser and the corresponding headless
require 'watir'

class Browser
  attr_accessor :browser, :headless

  def initialize(language = 'en_US')
    @headless = nil
    if ["production", "staging"].include?(ENV['RACK_ENV'])
      @headless = Headless.new
      @headless.start
    end
    prefs = {
      intl: {
        accept_languages: language
      }
    }
    @browser = Watir::Browser.new :chrome, prefs: prefs
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 60
    @browser.driver.manage.timeouts.implicit_wait = 20
  end

  def self.watir_errors
    [Watir::Exception::Error, Watir::Wait::TimeoutError]
  end

  def kill
    browser.close unless browser.nil?
    headless.destroy unless headless.nil?
  end

  def method_missing(method, *args)
    @browser.send(method, *args)
  end
end
