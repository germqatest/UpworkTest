require 'selenium-webdriver'
require_relative '../../utils/constants'
require_relative '../../utils/log'

class BaseTest
  class << self
    attr_reader :driver
  end

  # Define path to drivers
  Selenium::WebDriver::Firefox.driver_path = File.join(File.absolute_path('../../..', File.dirname(__FILE__)), 'drivers', 'geckodriver.exe')
  Selenium::WebDriver::Chrome.driver_path = File.join(File.absolute_path('../../..', File.dirname(__FILE__)), 'drivers', 'chromedriver.exe')
  Selenium::WebDriver::Edge.driver_path = File.join(File.absolute_path('../../..', File.dirname(__FILE__)), 'drivers', 'MicrosoftWebDriver.exe')

  # Browser setup
  if %w[chrome firefox edge].include?(Constants::BROWSER_NAME)
    @driver = Selenium::WebDriver.for :"#{Constants::BROWSER_NAME}"
    @driver.manage.window.maximize

    Log.message("* Browser up and running *\n")
  else
    Log.error("Unidentified browser type <#{Constants::BROWSER_NAME}> | :", true)
  end

  at_exit do
    @driver.quit

    Log.publish_results
  end
end