# frozen_string_literal: true

class SurveyModal::FreeformComponent < ViewComponent::Base
  def initialize(survey:)
    @survey = survey
  end

end
