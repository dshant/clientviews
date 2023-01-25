class AddVisitJob < ApplicationJob
  queue_as :default

  def perform(user_agent, remote_ip, visit_params, survey_id)
    visit = VisitProperties.new(user_agent, remote_ip, visit_params)
    visit_data = slice_data(visit.generate).merge({survey_id: survey_id})
    Visit.create!(visit_data)
  end

  private

  def slice_data(data)
    column_names = Visit.column_names
    data.slice(*column_names.map(&:to_sym)).select { |_, v| !v.nil? }
  end
end
