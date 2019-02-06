require_relative '../entities/freelancer_profile'

class SearchResultPage < BasePage

  #------------------------------------------------------------------------------------------#
  #                                           +Locators+                                     #
  #------------------------------------------------------------------------------------------#

  SEARCH_RESULT_LOCATOR = '//section//section[@data-compose-log-data][?]'.freeze
  SEARCH_RESULT_SECTION = ElementLocator.new(:xpath, '//section//section[@data-compose-log-data]')

  FREELANCER_NAME = ElementLocator.new(:xpath,
                                       SEARCH_RESULT_LOCATOR + '//div[contains(@class,"ellipsis")]//h4')
  FREELANCER_TITLE = ElementLocator.new(:xpath,
                                        SEARCH_RESULT_LOCATOR + '//div[contains(@class,"m-0-top-bottom")][not(contains(@class,"ellipsis"))]//h4')
  FREELANCER_DESCRIPTION = ElementLocator.new(:xpath,
                                              SEARCH_RESULT_LOCATOR + '//div[contains(@class,"d-lg-block")]//p')
  FREELANCER_SKILLS = ElementLocator.new(:xpath,
                                         SEARCH_RESULT_LOCATOR + '//a[contains(@class,"o-tag-skill")]')
  FREELANCER_ADDITIONAL_SKILLS = ElementLocator.new(:xpath,
                                                    SEARCH_RESULT_LOCATOR + '//div[@class="col-xs-12"]/span[@class="d-none"]')

  FREELANCER_PROFILE_LINK = ElementLocator.new(:xpath,
                                               SEARCH_RESULT_LOCATOR + '//div[contains(@class,"ellipsis")]//h4/a')

  #------------------------------------------------------------------------------------------#
  #                                            +Code+                                        #
  #------------------------------------------------------------------------------------------#

  # Get all results on 1 page
  #
  # @return [Array<FreelancerProfile>]
  def results
    Log.message('Storage search result >>')

    i = 1
    profiles = []

    while i <= search_result_number
      profile_name = get_element_text(FREELANCER_NAME, i).strip
      profile_title = get_element_text(FREELANCER_TITLE, i).strip
      profile_description = displayed?(FREELANCER_DESCRIPTION, i, false) ? get_element_text(FREELANCER_DESCRIPTION, i) : 'No description'
      profile_skills = if displayed?(FREELANCER_ADDITIONAL_SKILLS, i, false)
                         additional_skills = get_element_text(FREELANCER_ADDITIONAL_SKILLS, i).delete("\n").strip.split(',')
                         get_elements_text(FREELANCER_SKILLS, i).push(*additional_skills).each(&:strip!)
                       else
                         get_elements_text(FREELANCER_SKILLS, i).each(&:strip!)
                       end

      profiles << FreelancerProfile.new(profile_name, profile_title, profile_description, profile_skills)

      i += 1
    end
    Log.message('- Storage successful -')

    profiles
  end

  # Get number of elements in result search
  #
  # @return [Integer]
  def search_result_number
    get_elements(SEARCH_RESULT_SECTION).size
  end

  # Open freelancer page by index
  #
  # @param index [Integer]: Index of freelancer profile
  #
  # @return [FreelancerProfilePage]: Freelancer profile page
  def open_freelancer_profile(index)
    click_wait(FREELANCER_PROFILE_LINK, 10, index)

    FreelancerProfilePage.new(BaseTest.driver)
  end
end