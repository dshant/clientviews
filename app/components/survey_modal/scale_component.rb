# frozen_string_literal: true

class SurveyModal::ScaleComponent < ViewComponent::Base
  def initialize(survey:)
    @survey = survey
  end

end
