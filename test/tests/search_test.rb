require_relative 'base/base_test'

Dir[File.join(__dir__, '../pages', '*.rb')].each(&method(:require))

#-------------------------------------------------------------------------------------------------------
# SUMMARY: Searching for +keyword+ and check results
#-------------------------------------------------------------------------------------------------------
class SearchTest < BaseTest

  # [1] Run `<browser>`
  # [2] Clear `<browser>` cookies
  Log.step('Run browser and clear cookies')
  page = BasePage.new(BaseTest.driver)
  page.clear_cookies
  Log.done

  # [3] Go to www.upwork.com
  Log.step('Open upwork home page')
  home_page = HomePage.new(page.get(Constants::HOME_URL))
  Log.done

  # [4] Focus onto "Find freelancers"
  # [5] Enter `<keyword>` into the search input right from the dropdown
  # and submit it (click on the magnifying glass button)
  Log.step('Input <keyword> into the search field and submit')
  search_page = home_page.search_for(:freelancers, Constants::KEYWORD)
  Log.done

  # [6] Parse the 1st page with search results:
  # store info given on the 1st page of search results as structured data of any chosen by you type
  Log.step('Parse the 1st page with search results')
  freelancer_profiles = search_page.results
  Log.done

  # [7] Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer)
  # from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not.
  Log.step('Make sure at least one attribute of each item contains `<keyword>`')
  freelancer_profiles.each do |profile|
    profile.attr_check(Constants::KEYWORD)
    Log.done
  end

  # [8] Click on random freelancer's title
  # [9] Get into that freelancer's profile
  Log.step('Click on random freelancer`s title and get into that freelancer`s profile')
  profile_index = rand(1..search_page.search_result_number)
  Log.message("Open freelancer with index #{profile_index}")
  freelancer_profile_page = search_page.open_freelancer_profile(profile_index)
  Log.done

  # [10] Check that each attribute value is equal to one of those stored in the structure created in #67
  Log.step('Check that each attribute value is equal')
  freelancer_profile_page.profile_check(freelancer_profiles[profile_index - 1])
  Log.done

  # [11] Check whether at least one attribute contains `<keyword>`
  Log.step('Check whether at least one attribute contains `<keyword>`')
  freelancer_profile_page.attr_check(Constants::KEYWORD)
  Log.done
end