class SiteSurveyMembership < ApplicationRecord
  belongs_to :site
  belongs_to :survey
end
