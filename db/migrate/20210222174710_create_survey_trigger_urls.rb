class CreateSurveyTriggerUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_trigger_urls, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :url

      t.timestamps
    end
  end
end
