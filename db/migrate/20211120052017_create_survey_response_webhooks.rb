class CreateSurveyResponseWebhooks < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_response_webhooks, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :url
      t.string :token

      t.timestamps
    end
  end
end
