class AddVideoFeedbackDataToResponses < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :video_feedback_data, :string
  end
end
