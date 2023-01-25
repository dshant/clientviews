class AddSurveyTypeToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :survey_type, :string
  end
end
