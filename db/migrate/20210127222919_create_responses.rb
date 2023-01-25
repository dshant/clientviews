class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :value
      t.string :email

      t.timestamps
    end
  end
end
