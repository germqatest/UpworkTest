class FreelancerProfile
  attr_accessor :name, :title, :description, :skills

  def initialize(name, title, description, skills)
    @name = name
    @title = title
    @description = description
    @skills = skills
  end

  # Method check that at least one attribute contains text
  #
  # @param text [String]: Text needed to be contains
  #
  # @return [Boolean]: true if contains
  def attr_check(text)
    Log.message("Checking attributes contains <#{text}> for #{@name} >>")

    if @title.include?(text) || @description.include?(text) || @skills.join(' ').include?(text)

      @title.include?(text) ? Log.message("Title attribute contains <#{text}>") : Log.warning("Title attribute NOT contains <#{text}>")
      @description.include?(text) ? Log.message("Description attribute contains <#{text}>") : Log.warning("Description attribute NOT contains <#{text}>")
      @skills.join(' ').include?(text) ? Log.message("Skills attribute contains <#{text}>") : Log.warning("Skills attribute NOT contains <#{text}>")

      true
    else

      Log.error("No one attribute contains <#{text}>")

      false
    end
  end
end