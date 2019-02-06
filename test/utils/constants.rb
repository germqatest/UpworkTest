#-------------------------------------------------------------------------------------------------------
# Class for needed constants storage
#-------------------------------------------------------------------------------------------------------

class Constants
  HOME_URL = 'https://www.upwork.com'.freeze

  BROWSER_NAME = ENV.fetch('BROWSER') { :edge }
  KEYWORD = ENV.fetch('KEYWORD') { 'Ruby' }
end