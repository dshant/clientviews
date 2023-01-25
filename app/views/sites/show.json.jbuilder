json.cache! ['v1', @site, (@site&.surveys&.order(updated_at: :desc)&.last&.updated_at&.iso8601 || @site.updated_at.iso8601)] do
  json.call(@site, :id, :domain, :created_at)
  json.surveys @site.surveys do |survey|
    json.call(survey, :id, :header, :image, :name, :person_name, :position)
    json.html render(SurveyModalComponent.new(survey: survey))
    json.js render(SurveyModalJavascriptComponent.new(survey: survey))
  end
end
