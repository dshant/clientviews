class CreateSiteSurveyMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :site_survey_memberships, id: :uuid do |t|
      t.references :site, null: false, foreign_key: true, type: :uuid
      t.references :survey, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
