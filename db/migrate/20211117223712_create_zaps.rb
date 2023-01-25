class CreateZaps < ActiveRecord::Migration[6.1]
  def change
    create_table :zaps, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :zapier_id
      t.string :hook_url

      t.timestamps
    end
  end
end
