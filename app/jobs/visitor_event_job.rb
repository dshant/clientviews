class VisitorEventJob < ApplicationJob
  queue_as :default

  def perform(user, yoha_id, action, survey_id=nil)
    return if yoha_id.blank?

    survey_id = survey_id || user&.account&.surveys&.first&.id

    puts "SID: #{survey_id}"

    VisitorEvent.create!(visitor_token: yoha_id, event: action, survey_id: survey_id)
  end
end
