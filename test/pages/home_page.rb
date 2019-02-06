require_relative '../entities/element_locator'

class HomePage < BasePage

  #------------------------------------------------------------------------------------------#
  #                                           +Locators+                                     #
  #------------------------------------------------------------------------------------------#

  SEARCH_FIELD = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//input[@name="q"]')
  SEARCH_BUTTON = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//button[contains(.,"Submit search")]')
  SEARCH_CATEGORY_BUTTON = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//button[contains(.,"Switch search source")]')

  DROPDOWN_OPTION_FREELANCERS = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//li[@data-label="Freelancers"]')
  DROPDOWN_OPTION_JOBS = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//li[@data-label="Jobs"]')

  #------------------------------------------------------------------------------------------#
  #                                            +Code+                                        #
  #------------------------------------------------------------------------------------------#

  # Searching for chosen category
  #
  # @param category [Symbol]: Type of searching items
  #                 e.g. :freelancers, :jobs
  #
  # @param keyword [String]: Search term
  #
  # @return [SearchResultPage]: Page with given search results
  def search_for(category, keyword)

    unless %w[jobs freelancers].include?(category.to_s)
      Log.error("Category #{category} is not allowed")
      return
    end

    Log.message("Input <#{keyword}> and search for #{category} >>")

    Log.message("Choose <#{category.capitalize}> category")
    click_wait(SEARCH_CATEGORY_BUTTON, 3)

    if category.to_s.include?('freelancers')
      click(DROPDOWN_OPTION_FREELANCERS) unless selected?(DROPDOWN_OPTION_FREELANCERS, nil, false)
    else
      click(DROPDOWN_OPTION_JOBS) unless selected?(DROPDOWN_OPTION_JOBS, nil, false)
    end

    Log.message("Input <#{keyword}> and click on search button")
    click(SEARCH_FIELD)
    type(SEARCH_FIELD, keyword)
    click_wait(SEARCH_BUTTON, 10)

    SearchResultPage.new(BaseTest.driver)
  end
end