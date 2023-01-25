class AddThankYouNoteToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :thank_you_note, :string
  end
end
