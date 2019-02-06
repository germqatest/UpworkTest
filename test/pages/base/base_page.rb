require 'selenium-webdriver'

class BasePage
  class << self
    attr_reader :browser
  end

  def initialize(browser)
    @browser = browser
  end

  #===========================================================================================
  # Base actions
  #===========================================================================================

  # Open defined url
  #
  # @param [String]: URL needed to open
  def get(url)
    Log.message("Open <#{url}> page >>")

    @browser.get(url)
    sleep 2

    @browser
  end

  # Closing current page
  def close
    Log.message('Closing page >>')

    if @browser.nil?
      Log.error('Page is already closed')
    else
      @browser.close
      Log.message('Page closed')
    end
  end

  # Clear all cookies from browser
  def clear_cookies
    Log.message('Delete all cookies >>')

    @browser.manage.delete_all_cookies
  end

  # Get the URL of the current page
  #
  # @return [String]
  def url
    @browser.current_url
  end

  # Get the title of the current page
  #
  # @return [String]
  def title
    @browser.title
  end

  #===========================================================================================
  # Element actions
  #===========================================================================================

  # Get element by locator
  #
  # @param [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [Element]: Founded element
  def get_element(element, arg = nil)
    if element.instance_of?(ElementLocator)
      if arg.nil?
        @browser.find_element("#{element.locator_type}": element.locator)
      else
        @browser.find_element("#{element.locator_type}": element.locator.gsub('?', arg.to_s))
      end
    else
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
    end
  end

  # Get element by locator
  #
  # @param element [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [Array<Element>]: Array of founded elements
  def get_elements(element, arg = nil)
    if element.instance_of?(ElementLocator)
      if arg.nil?
        @browser.find_elements("#{element.locator_type}": element.locator)
      else
        @browser.find_elements("#{element.locator_type}": element.locator.gsub('?', arg.to_s))
      end
    else
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
    end
  end

  #===========================================================================================
  # Text actions
  #===========================================================================================

  # Get element text
  #
  # @param element [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [String]: Text of define element if element displayed
  def get_element_text(element, arg = nil)
    get_element(element, arg).text
  end

  # Get elements text
  #
  # @param element [ElementLocator]: Locator of elements need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  #
  # @return [Array<String>]: Text of define element if element displayed
  def get_elements_text(element, arg = nil)
    elements_text = []

    get_elements(element, arg).each do |web_element|
      elements_text << web_element.text
    end

    elements_text
  end

  #===========================================================================================
  # Status actions
  #===========================================================================================

  # Check element displayed
  #
  # @param element [ElementLocator]: Locator of element need to check
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  #
  # @param with_log [Boolean]: Set false if log is not needed
  #
  # @return [Boolean]: if at least one is displayed return true
  def displayed?(element, arg = nil, with_log = true)
    Log.message('Checking element displayed >>') if with_log

    unless element.instance_of?(ElementLocator)
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
      return
    end

    # Array should be empty if element(s) absent. This method quicker than waiting for error
    if get_elements(element, arg).empty?
      Log.warning("Element(s) #{element.element_id} is not displayed") if with_log
      false
    else
      Log.message("Element(s) #{element.element_id} is displayed") if with_log
      true
    end
  end

  # Check menu element selected
  #
  # @param element [ElementLocator]: Locator of element need to check
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @param with_log [Boolean]: Set false if log is not needed
  #
  # @return [Boolean]: if selected return true
  def selected?(element, arg = nil, with_log = true)
    Log.message('Checking element selected >>') if with_log

    unless element.instance_of?(ElementLocator)
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
      return
    end

    if get_element(element, arg).selected?
      Log.message("Elements with #{element.element_id} is selected") if with_log
      true
    else
      Log.message("Elements with #{element.element_id} is NOT selected") if with_log
      false
    end
  end

  #===========================================================================================
  # Click actions
  #===========================================================================================

  # Click on element by locator
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  def click(element, arg = nil)
    if displayed?(element, arg, false)
      get_element(element, arg).click
    else
      Log.error("Element #{element.element_id} is absent")
    end
  end

  # Click on element and wait some time
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param sec [Integer]: Waiting time in seconds
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  def click_wait(element, sec, arg = nil)
    click(element, arg)
    wait(sec)
  end

  # Click on element and wait until needed element displayed
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @param timeout [Integer]: Timeout in seconds
  #
  # @param element_waiting_for [ElementLocator]: Locator of element waiting for
  #
  # @param second_arg [Symbol, String, Integer]: Argument in element waiting for locator
  def click_wait_until_displayed(element, timeout, element_waiting_for, arg = nil, second_arg = nil)
    Log.message("Clicking and wait until element #{element_waiting_for.element_id} present >>")

    click(element, arg)
    wait_until_element_displayed(element_waiting_for, timeout, second_arg)
  end

  #===========================================================================================
  # Type actions
  #===========================================================================================

  # Type text in text field
  #
  # @param field [ElementLocator]: Locator of text field
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @param text [String]: Text to type
  def type(field, text, arg = nil)
    get_element(field, arg).send_keys(text)
  end

  # Press button in specify area
  #
  # @param area [ElementLocator]: Locator of area where need to press button
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @param button [Symbol]: Button need to press
  #     e.g. :enter, :tab, :space
  def press_button(area, button, arg = nil)
    Log.message("Press #{button} button >>")

    get_element(area, arg).send_keys(button)
  end

  #===========================================================================================
  # Wait actions
  #===========================================================================================

  # Wait some time in seconds
  #
  # @param sec [Integer]: Waiting time
  def wait(sec = 5)
    Log.message("Waiting #{sec} sec >>")

    sec.instance_of?(Integer) ? sleep(sec) : Log.error("Waiting time is not integer: [#{sec}]")
  end

  # Waiting for element present
  #
  # @param element [ElementLocator]: Element waiting for
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @param timeout [Integer]: Timeout in seconds
  def wait_until_element_displayed(element, timeout, arg = nil)
    Log.message('Waiting until element displayed >>')

    if timeout.instance_of?(Integer) && element.instance_of?(ElementLocator)
      Selenium::WebDriver::Wait.new(timeout: timeout).until { displayed?(element, arg, false) }
    elsif !timeout.instance_of?(Integer) && element.instance_of?(ElementLocator)
      Selenium::WebDriver::Wait.new(timeout: 10).until { displayed?(element, arg, false) }
      Log.warning('Param <timeout> is not [Integer] ---Ignored and default used')
    else
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
    end
  end
end
