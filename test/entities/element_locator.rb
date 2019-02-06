class ElementLocator
  attr_accessor :locator, :locator_type, :element_id

  def initialize(locator_type, locator)
    if %i[id name class link css xpath].include?(locator_type)
      @locator_type = locator_type
      @locator = locator
      @element_id = "#{locator_type}_#{Time.now.to_i}"
    else
      Log.error('Locator type is unknown')
    end
  end
end