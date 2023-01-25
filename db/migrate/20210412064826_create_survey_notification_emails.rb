class CreateSurveyNotificationEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_notification_emails, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :email
      t.boolean :active

      t.timestamps
    end
  end
end
