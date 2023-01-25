class AddVideoFeedbackEnabledToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :video_feedback_enabled, :string
  end
end
