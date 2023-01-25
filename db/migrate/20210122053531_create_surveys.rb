class CreateSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :surveys, id: :uuid do |t|
      t.string :name
      t.string :border_color
      t.string :header
      t.string :person_name
      t.text :body
      t.string :survey_type
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
