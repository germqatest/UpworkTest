require_relative '../entities/element_locator'
require_relative 'base/base_page'

class FreelancerProfilePage < BasePage

  #------------------------------------------------------------------------------------------#
  #                                           +Locators+                                     #
  #------------------------------------------------------------------------------------------#

  FREELANCER_NAME = ElementLocator.new(:xpath, '//div[contains(@class,"air-card")]//div[@class="media"]//h2')
  COMPANY_NAME = ElementLocator.new(:xpath, '//div[@class="row"]//div[@class="media"]//h2')

  FREELANCER_TITLE = ElementLocator.new(:xpath, '//div[@class="overlay-container"]//h3')
  COMPANY_TITLE = ElementLocator.new(:xpath, '//div[contains(@class,"air-card")]//h3[@ng-if="vm.profile.title"]')

  FREELANCER_DESCRIPTION = ElementLocator.new(:xpath, '//o-profile-overview[@words=80]//p')
  COMPANY_DESCRIPTION = ElementLocator.new(:xpath, '//div[contains(@class,"air-card")]//div[@o-text-truncate]')

  FREELANCER_SKILLS = ElementLocator.new(:xpath, '//div[contains(@class,"o-profile-skills")]/a')

  ALERT_WARNING = ElementLocator.new(:xpath, '//div[@class="container"]//div[@type="warning"]')

  #------------------------------------------------------------------------------------------#
  #                                            +Code+                                        #
  #------------------------------------------------------------------------------------------#

  # Checking actual profile on page with expected
  #
  # @param profile [FreelancerProfile]: Freelancer/Company profile
  def profile_check(profile)
    Log.message("Checking #{profile.name} profile >>")

    unless displayed?(FREELANCER_NAME, nil, false) || displayed?(COMPANY_NAME, nil, false)
      if displayed?(ALERT_WARNING, nil, false)
        Log.error('This freelancer`s profile is only available to Upwork customers')
      else
        Log.error('Page missing or unexpected error')
      end
    end

    #### Name check
    if displayed?(FREELANCER_NAME, nil, false)

      if get_element_text(FREELANCER_NAME).include?(profile.name)
        Log.message('Name attribute check successful')
      else
        Log.warning("Name attribute check failed\nExpected: #{profile.name}\nActual: #{get_element_text(FREELANCER_NAME)}")
      end
    else

      if get_element_text(COMPANY_NAME).include?(profile.name)
        Log.message('Name attribute check successful')
      else
        Log.warning("Name attribute check failed\nExpected: #{profile.name}\nActual: #{get_element_text(COMPANY_NAME)}")
      end
    end

    #### Title check
    if displayed?(FREELANCER_TITLE, nil, false)

      if get_element_text(FREELANCER_TITLE).include?(profile.title)
        Log.message('Title attribute check successful')
      else
        Log.warning("Title attribute check failed\nExpected: #{profile.title}\nActual: #{get_element_text(FREELANCER_TITLE)}")
      end
    elsif displayed?(COMPANY_TITLE, nil, false)

      if get_element_text(COMPANY_TITLE).include?(profile.title)
        Log.message('Title attribute check successful')
      else
        Log.warning("Title attribute check failed\nExpected: #{profile.title}\nActual: #{get_element_text(COMPANY_TITLE)}")
      end
    else

      Log.message('Profile has no title displayed')
      Log.warning('Title attribute check skipped')
    end

    #### Description check
    if displayed?(FREELANCER_DESCRIPTION, nil, false)
      # Short profile description without non letter characters
      expected_text = profile.description.gsub(/\W+/, '')

      # Full profile description without non letter characters and cut to expected text length
      actual_text = get_element_text(FREELANCER_DESCRIPTION).gsub(/\W+/, '')[0..(expected_text.length - 1)]

      if actual_text.include?(expected_text)
        Log.message('Description attribute check successful')
      else
        Log.warning("Description attribute check failed\nExpected: #{profile.description}\nActual: #{get_element_text(FREELANCER_DESCRIPTION)}")
      end
    elsif displayed?(COMPANY_DESCRIPTION, nil, false)
      # Short profile description without non letter characters
      expected_text = profile.description.gsub(/\W+/, '')

      # Full profile description without non letter characters and cut to expected text length
      actual_text = get_element_text(COMPANY_DESCRIPTION).gsub(/\W+/, '')[0..(expected_text.length - 1)]

      if actual_text.include?(expected_text)
        Log.message('Description attribute check successful')
      else
        Log.warning("Description attribute check failed\nExpected: #{profile.description}\nActual: #{get_element_text(COMPANY_DESCRIPTION)}")
      end
    else

      if 'No description'.include?(profile.description)
        Log.message('Description attribute check successful')
      else
        Log.warning("Description attribute check failed\nExpected: #{profile.description}\nActual: No description")
      end
    end

    #### Skills check
    if displayed?(FREELANCER_SKILLS, nil, false)
      # Expected profile skills sorted by name ASC
      expected_skills = profile.skills.sort.to_s

      # Actual profile skills sorted by name ASC and trimmed
      actual_skills = get_elements_text(FREELANCER_SKILLS).each(&:strip!).sort.to_s

      if actual_skills.include?(expected_skills)
        Log.message('Skills attribute check successful')
      else
        Log.warning("Skills attribute check failed\nExpected: #{expected_skills}\nActual: #{actual_skills}")
      end
    else

      Log.message('Company profile has no skills displayed')
      Log.warning('Skills attribute check skipped')
    end
  end

  # Checking profile attributes contains search keyword
  #
  # @param keyword [String]: Search keyword
  def attr_check(keyword)
    Log.message("Checking attributes contains <#{keyword}> >>")

    ## Title check
    if displayed?(FREELANCER_TITLE, nil, false)
      get_element_text(FREELANCER_TITLE).include?(keyword) ? Log.message("Title attribute contains <#{keyword}>") : Log.warning("Title attribute NOT contains <#{keyword}>")
    else
      get_element_text(COMPANY_TITLE).include?(keyword) ? Log.message("Title attribute contains <#{keyword}>") : Log.warning("Title attribute NOT contains <#{keyword}>")
    end

    ## Description check
    if displayed?(FREELANCER_DESCRIPTION, nil, false)
      get_element_text(FREELANCER_DESCRIPTION).include?(keyword) ? Log.message("Description attribute contains <#{keyword}>") : Log.warning("Description attribute NOT contains <#{keyword}>")
    else
      get_element_text(COMPANY_DESCRIPTION).include?(keyword) ? Log.message("Description attribute contains <#{keyword}>") : Log.warning("Description attribute NOT contains <#{keyword}>")
    end

    ## Skills check
    if displayed?(FREELANCER_SKILLS, nil, false)
      is_contains_keyword = false

      get_elements_text(FREELANCER_SKILLS).each do |skill|
        is_contains_keyword = true if skill.include?(keyword)
      end

      is_contains_keyword ? Log.message("Skills attribute contains <#{keyword}>") : Log.warning("Skills attribute NOT contains <#{keyword}>")
    else
      Log.message("Company profile has no skills displayed, but agency member may contains <#{keyword}> in skills")
    end
  end
end